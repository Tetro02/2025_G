module Test_Top (
    // ===================== DDR（Zynq PS 固定端口） =====================
    inout  [14:0]  DDR_addr,
    inout  [2:0]   DDR_ba,
    inout          DDR_cas_n,
    inout          DDR_ck_n,
    inout          DDR_ck_p,
    inout          DDR_cke,
    inout          DDR_cs_n,
    inout  [3:0]   DDR_dm,
    inout  [31:0]  DDR_dq,
    inout  [3:0]   DDR_dqs_n,
    inout  [3:0]   DDR_dqs_p,
    inout          DDR_odt,
    inout          DDR_ras_n,
    inout          DDR_reset_n,
    inout          DDR_we_n,

    // ===================== FIXED_IO（Zynq PS 固定端口） =====================
    inout          FIXED_IO_ddr_vrn,
    inout          FIXED_IO_ddr_vrp,
    inout  [53:0]  FIXED_IO_mio,
    inout          FIXED_IO_ps_clk,
    inout          FIXED_IO_ps_porb,
    inout          FIXED_IO_ps_srstb,

    // ===================== UART（PS 引出） =====================
    input          UART_0_1_rxd,
    output         UART_0_1_txd,

    // ===================== ADC 接口 =====================
    input  [11:0]  adc_data_in_1,
    input  [11:0]  adc_data_in_2,
    output         clk_out_adc_1,
    output         clk_out_adc_2,

    // ===================== DAC 接口 =====================
    output [13:0]  dac_data_out,
    output         clk_out_dac
);

    // =========================================================
    //  1. PS → PL 控制信号（AXI-Lite 寄存器映射）
    // =========================================================

    // PS 主时钟 50MHz
    wire         FCLK_CLK0;

    // slv_reg0: 控制/状态
    wire [31:0]  ctrl_start_end_flag;

    // slv_reg1: DDS 频率字
    wire [31:0]  dds_ctrl_reg0;

    // slv_reg2: DDS 控制（波形、相位、幅度）
    wire [31:0]  dds_ctrl_reg1;

    // slv_reg3: 校准参数
    wire [31:0]  slv_reg3;

    // DDS 原始输出（14-bit unsigned）
    wire [13:0]  dds_dac_out;

    // =========================================================
    //  2. DAC 输出寄存器
    // =========================================================

    reg [13:0] dac_data_out_reg;
    assign dac_data_out = dac_data_out_reg;

    // =========================================================
    //  3. 校准参数提取（slv_reg3 解码）
    // =========================================================

    // 粗调位移 0~31（右移位数）
    wire [4:0]  cal_shift = slv_reg3[4:0];

    // 微调乘数 Q1.15（0x8000 = 1.0）
    wire [15:0] cal_coef  = slv_reg3[20:5];

    // =========================================================
    //  4. 模式互斥（多路复用控制）
    // =========================================================

    wire fir_coef_reload_mode;
    wire adc_bram_mode;
    wire dds_mode;
    wire fir_dac_mode;
    wire cal_mode;
    wire use_fir_chain;

    // bit1 最高优先级 — FIR 系数重载
    assign fir_coef_reload_mode =  ctrl_start_end_flag[1];

    // bit4 — 校准模式
    assign cal_mode    = !ctrl_start_end_flag[1]
                      && !ctrl_start_end_flag[3]
                      &&  ctrl_start_end_flag[4];

    // bit2 — DDS 独立输出（扫频）；bit4 — 校准模式下也跑 DDS
    assign dds_mode    = !ctrl_start_end_flag[1]
                      && !ctrl_start_end_flag[3]
                      && (ctrl_start_end_flag[2] || ctrl_start_end_flag[4]);

    // bit0 — ADC 采样写 BRAM（扫频 & 校准共用，toggle bit0 触发新一轮采集）
    assign adc_bram_mode = !ctrl_start_end_flag[1]
                        && !ctrl_start_end_flag[3]
                        &&  ctrl_start_end_flag[0];

    // bit3 — 模仿模式（ADC → FIR → shift → mult → DAC）
    assign fir_dac_mode = !ctrl_start_end_flag[1]
                       && !ctrl_start_end_flag[0]
                       && !ctrl_start_end_flag[2]
                       && !ctrl_start_end_flag[4]
                       &&  ctrl_start_end_flag[3];

    // 校准(bit4) 或 模仿(bit3) → 走 FIR→shift→mult→DAC
    assign use_fir_chain = cal_mode || fir_dac_mode;

    // =========================================================
    //  5. FIR 复位同步（毛刺消除）
    // =========================================================

    reg  [1:0] rst_sync;
    wire       rst_n_fir_synced;

    always @(posedge FCLK_CLK0 or negedge use_fir_chain) begin
        if (!use_fir_chain)
            rst_sync <= 2'b0;
        else
            rst_sync <= {rst_sync[0], 1'b1};
    end

    assign rst_n_fir_synced = rst_sync[1];

    // =========================================================
    //  6. ODDR 时钟输出（ADC / DAC 采样时钟）
    // =========================================================

    ODDR #(
        .DDR_CLK_EDGE("OPPOSITE_EDGE"),
        .INIT        (1'b0),
        .SRTYPE      ("SYNC")
    ) u_oddr_clk_adc1 (
        .Q (clk_out_adc_1),
        .C (FCLK_CLK0),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R (1'b0),
        .S (1'b0)
    );

    ODDR #(
        .DDR_CLK_EDGE("OPPOSITE_EDGE"),
        .INIT        (1'b0),
        .SRTYPE      ("SYNC")
    ) u_oddr_clk_adc2 (
        .Q (clk_out_adc_2),
        .C (FCLK_CLK0),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R (1'b0),
        .S (1'b0)
    );

    ODDR #(
        .DDR_CLK_EDGE("OPPOSITE_EDGE"),
        .INIT        (1'b0),
        .SRTYPE      ("SYNC")
    ) u_oddr_clk_dac (
        .Q (clk_out_dac),
        .C (FCLK_CLK0),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R (1'b0),
        .S (1'b0)
    );

    // =========================================================
    //  7. ADC / BRAM 接口信号
    // =========================================================

    wire         end_adc_flag;
    wire [16:0]  addrb;
    wire [16:0]  addra;
    wire [31:0]  dinb;
    wire [31:0]  doutb;
    wire [3:0]   web;
    reg  [16:0]  bram_addr;

    // =========================================================
    //  8. FIR 系数重载通道（AXI-Stream）
    // =========================================================

    wire        s_axis_reload_tvalid;
    wire        s_axis_reload_tready;
    wire        s_axis_reload_tlast;
    wire [15:0] s_axis_reload_tdata;
    wire        s_axis_config_tvalid;
    wire        s_axis_config_tready;
    wire [7:0]  s_axis_config_tdata;

    // =========================================================
    //  9. FIR 数据通道
    // =========================================================

    wire signed [39:0] dac_data;
    wire               dac_valid;

    // =========================================================
    //  10. FIR 输入 MUX
    //      校准模式 — 用 DDS 作为激励源
    //      模仿模式 — 用 ADC 实时数据
    // =========================================================

    // DDS 输出（14-bit unsigned）→ 转换为 12-bit signed，去 DC
    wire signed [11:0] dds_to_fir;
    assign dds_to_fir = $signed(dds_dac_out[13:2]) - 12'sd2048;

    wire [11:0] fir_adc_input;
    assign fir_adc_input = cal_mode ? dds_to_fir : adc_data_in_1;

    // =========================================================
    //  11. shift + multiplier 链路
    //      FIR 输出 40-bit signed → 粗调右移 → 微调乘 Q1.15 → 截位 → +DC
    // =========================================================

    // 粗调：算术右移 cal_shift 位
    wire signed [39:0] fir_shifted;
    assign fir_shifted = dac_data >>> cal_shift;

    // 微调 × Q1.15（cal_coef）
    wire signed [55:0] mult_full;
    assign mult_full = fir_shifted * $signed({1'b0, cal_coef});

    // Q1.15 → 整数（右移 15）
    wire signed [40:0] mult_scaled;
    assign mult_scaled = mult_full >>> 15;

    // +DC 偏移 → 14-bit unsigned
    wire signed [14:0] cal_dac_signed;
    assign cal_dac_signed = mult_scaled[14:0] + 15'sd8192;

    // =========================================================
    //  12. BRAM 地址 MUX
    //      ADC 采样 → BRAM 写地址
    //      系数重载 → BRAM 读地址
    // =========================================================

    always @(*) begin
        if (adc_bram_mode)
            bram_addr = addrb;
        else if (fir_coef_reload_mode)
            bram_addr = addra;
        else
            bram_addr = 17'd0;
    end

    // =========================================================
    //  13. DAC 输出 MUX
    //      use_fir_chain — FIR→shift→mult 链路的输出
    //      dds_mode     — 原始 DDS 直通
    //      其他          — 输出 0
    // =========================================================

    always @(posedge FCLK_CLK0) begin
        if (use_fir_chain) begin
            if (cal_dac_signed <= 0)
                dac_data_out_reg <= 14'd1;
            else if (cal_dac_signed >= 16383)
                dac_data_out_reg <= 14'd16382;
            else
                dac_data_out_reg <= cal_dac_signed[13:0];
        end
        else if (dds_mode) begin
            dac_data_out_reg <= dds_dac_out;
        end
        else begin
            dac_data_out_reg <= 14'd0;
        end
    end

    // =========================================================
    //  14. 子模块例化
    // =========================================================

    // -------------------------------------------------------
    //  1) ADC 采样 + 写 BRAM
    // -------------------------------------------------------
    adc_bram_sample adc_bram_sample_inst (
        .clk_bram    (FCLK_CLK0),
        .rst_n       (adc_bram_mode),
        .addrb       (addrb),
        .dinb        (dinb),
        .web         (web),
        .adc_data_1  (adc_data_in_1),
        .adc_data_2  (adc_data_in_2),
        .adc_end_flag(end_adc_flag)
    );

    // -------------------------------------------------------
    //  2) BRAM 读系数 + FIR 重载（AXI-Stream）
    // -------------------------------------------------------
    bram_read_fir_reload bram_read_fir_reload_inst (
        .clk_bram               (FCLK_CLK0),
        .rst_n                  (fir_coef_reload_mode),
        .addra                  (addra),
        .douta                  (doutb),

        .s_axis_reload_tvalid   (s_axis_reload_tvalid),
        .s_axis_reload_tready   (s_axis_reload_tready),
        .s_axis_reload_tlast    (s_axis_reload_tlast),
        .s_axis_reload_tdata    (s_axis_reload_tdata),

        .s_axis_config_tvalid   (s_axis_config_tvalid),
        .s_axis_config_tready   (s_axis_config_tready),
        .s_axis_config_tdata    (s_axis_config_tdata)
    );

    // -------------------------------------------------------
    //  3) FIR 滤波器（1001-tap 对称）
    // -------------------------------------------------------
    fir_adc12_dac8 fir_adc12_dac8_inst (
        .aclk                   (FCLK_CLK0),
        .aresetn                (rst_n_fir_synced),

        .adc_data               (fir_adc_input),
        .adc_valid              (use_fir_chain),

        .dac_data               (dac_data),
        .dac_valid              (dac_valid),

        .s_axis_reload_tvalid   (s_axis_reload_tvalid),
        .s_axis_reload_tready   (s_axis_reload_tready),
        .s_axis_reload_tlast    (s_axis_reload_tlast),
        .s_axis_reload_tdata    (s_axis_reload_tdata),

        .s_axis_config_tvalid   (s_axis_config_tvalid),
        .s_axis_config_tready   (s_axis_config_tready),
        .s_axis_config_tdata    (s_axis_config_tdata)
    );

    // -------------------------------------------------------
    //  4) DDS（10Hz ~ 2MHz）
    // -------------------------------------------------------
    dds_10hz_2mhz #(
        .PHASE_W (28),
        .ADDR_W  (11),
        .DATA_W  (14)
    ) u_dds (
        .clk       (FCLK_CLK0),
        .rst_n     (dds_mode),
        .freq_word (dds_ctrl_reg0[27:0]),
        .phase_off (dds_ctrl_reg1[10:0]),
        .wave_sel  (dds_ctrl_reg1[12:11]),
        .amplitude (dds_ctrl_reg1[20:13]),
        .dac_out   (dds_dac_out)
    );

    // -------------------------------------------------------
    //  5) PS 端 BD wrapper
    // -------------------------------------------------------
    design_1_wrapper design_1_wrapper_inst (
        .DDR_addr           (DDR_addr),
        .DDR_ba             (DDR_ba),
        .DDR_cas_n          (DDR_cas_n),
        .DDR_ck_n           (DDR_ck_n),
        .DDR_ck_p           (DDR_ck_p),
        .DDR_cke            (DDR_cke),
        .DDR_cs_n           (DDR_cs_n),
        .DDR_dm             (DDR_dm),
        .DDR_dq             (DDR_dq),
        .DDR_dqs_n          (DDR_dqs_n),
        .DDR_dqs_p          (DDR_dqs_p),
        .DDR_odt            (DDR_odt),
        .DDR_ras_n          (DDR_ras_n),
        .DDR_reset_n        (DDR_reset_n),
        .DDR_we_n           (DDR_we_n),

        .FIXED_IO_ddr_vrn   (FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp   (FIXED_IO_ddr_vrp),
        .FIXED_IO_mio       (FIXED_IO_mio),
        .FIXED_IO_ps_clk    (FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb   (FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb  (FIXED_IO_ps_srstb),

        .UART_0_1_rxd       (UART_0_1_rxd),
        .UART_0_1_txd       (UART_0_1_txd),

        .IRQ_F2P_0          (end_adc_flag),
        .slv_reg0_o_0       (ctrl_start_end_flag),
        .slv_reg1_o_0       (dds_ctrl_reg0),
        .slv_reg2_o_0       (dds_ctrl_reg1),
        .slv_reg3_o_0       (slv_reg3),

        .FCLK_CLK0_0        (FCLK_CLK0),

        .addrb_0            ({15'd0, bram_addr}),
        .clkb_0             (FCLK_CLK0),
        .dinb_0             (dinb),
        .doutb_0            (doutb),
        .enb_0              (1'b1),
        .web_0              (web),
        .rstb_0             (1'b0)
    );

endmodule
