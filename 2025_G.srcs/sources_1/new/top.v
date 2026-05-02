module Test_Top  (
    DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    UART_0_1_rxd,
    UART_0_1_txd,
    clk_out_adc_1,
    clk_out_adc_2,
    adc_data_in_1,
    adc_data_in_2,
    dac_data_out,
    clk_out_dac
    );
	
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input UART_0_1_rxd;
  output UART_0_1_txd;

  input [11:0] adc_data_in_1; // ADC采样数据输入
  input [11:0] adc_data_in_2; // ADC采样数据输入
  output clk_out_adc_1;            // 输出到ADC的时钟
  output clk_out_adc_2;            // 输出到ADC的时钟

  output [13:0] dac_data_out;       // 14bit无符号DAC输出数据
  output clk_out_dac;             // 输出到DAC的时钟

  // ===================== 控制信号提前声明 =====================
  wire        FCLK_CLK0;          // PS输出50MHz时钟
  wire [31:0] ctrl_start_end_flag;// PS控制总线（slv_reg0）
  wire [31:0] dds_ctrl_reg0;      // DDS控制寄存器0（slv_reg1）：频率字
  wire [31:0] dds_ctrl_reg1;      // DDS控制寄存器1（slv_reg2）：相位/波形/幅度
  wire [13:0] dds_dac_out;        // DDS输出数据 [14bit]

  // ===================== 内部信号声明 =====================
  reg [13:0] dac_data_out_reg;    // DAC数据中间寄存器 [14bit]
  reg        clk_out_dac_reg;      // DAC时钟中间寄存器
  wire       rst_n_fir;            // FIR模式复位信号（未同步）
  wire       rst_n_fir_synced;     // 同步后的复位信号

  // 38bit有符号数 → 14bit无符号缩放参数
  // FIR输出范围 ±2^28 = ±268435456, 映射到 0~16383 (14bit)
  // 缩放因子: 16383 / 268435456 = 1/16384 ≈ 右移14位
  localparam signed OFFSET_FIR_14 = (14'd1 << 13); // 8192, 14bit中点
  // 饱和限幅边界
  localparam signed DAC_DATA_MIN = -29'sd268435455; // -2^28
  localparam signed DAC_DATA_MAX =  29'sd268435455; //  2^28

// ===================== 模式互斥逻辑 =====================
wire       fir_coef_reload_mode;
wire       adc_bram_mode;
wire       dds_mode;
wire       fir_dac_mode;

// 1. 系数重载模式（最高优先级）
assign fir_coef_reload_mode = ctrl_start_end_flag[1];
// 2. ADC采样模式：仅在非系数重载、非FIR模式时有效
assign adc_bram_mode = !fir_coef_reload_mode && !ctrl_start_end_flag[3] && ctrl_start_end_flag[0];
// 3. DDS模式：仅在非系数重载、非FIR模式时有效
assign dds_mode = !fir_coef_reload_mode && !ctrl_start_end_flag[3] && ctrl_start_end_flag[2];
// 4. FIR模式：仅在非系数重载、非ADC、非DDS模式时有效
assign fir_dac_mode = !fir_coef_reload_mode && !ctrl_start_end_flag[0] && !ctrl_start_end_flag[2] && ctrl_start_end_flag[3];

  // ===================== 复位同步器 =====================
  reg [1:0] rst_sync;
  assign rst_n_fir = fir_dac_mode;
  always @(posedge FCLK_CLK0 or negedge rst_n_fir) begin
      if (!rst_n_fir)
          rst_sync <= 2'b0;
      else
          rst_sync <= {rst_sync[0], 1'b1};
  end
  assign rst_n_fir_synced = rst_sync[1];

  // ===================== ODDR 原语输出时钟 =====================
  ODDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
  ) u_oddr_clk_adc1 (
      .Q(clk_out_adc_1),
      .C(FCLK_CLK0),
      .CE(1'b1),
      .D1(1'b1),
      .D2(1'b0),
      .R(1'b0),
      .S(1'b0)
  );
  ODDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
  ) u_oddr_clk_adc2 (
      .Q(clk_out_adc_2),
      .C(FCLK_CLK0),
      .CE(1'b1),
      .D1(1'b1),
      .D2(1'b0),
      .R(1'b0),
      .S(1'b0)
  );
  // DAC时钟：50MHz 连续时钟
  ODDR #(
      .DDR_CLK_EDGE("OPPOSITE_EDGE"),
      .INIT(1'b0),
      .SRTYPE("SYNC")
  ) u_oddr_clk_dac (
      .Q(clk_out_dac),
      .C(FCLK_CLK0),
      .CE(1'b1),
      .D1(1'b1),
      .D2(1'b0),
      .R(1'b0),
      .S(1'b0)
  );

  // DAC数据输出（通过中间reg assign）
  assign dac_data_out = dac_data_out_reg;

  // ===================== 控制信号定义 =====================
  wire        end_adc_flag;       // ADC采样完成标志

  // ===================== BRAM 接口信号 =====================
  wire [16:0] addrb;          // ADC写BRAM地址
  wire [31:0] dinb;           // ADC写BRAM数据
  wire [3:0]  web;            // ADC写BRAM使能
  wire [16:0] addra;          // FIR读BRAM地址
  wire [31:0] doutb;          // BRAM读出数据
  reg  [16:0] bram_addr;      // BRAM最终地址（MUX切换）

  // ===================== FIR 系数重载 AXI-Stream 信号 =====================
  wire        s_axis_reload_tvalid;
  wire        s_axis_reload_tready;
  wire        s_axis_reload_tlast;
  wire [15:0] s_axis_reload_tdata;
  wire        s_axis_config_tvalid;
  wire        s_axis_config_tready;
  wire [7:0]  s_axis_config_tdata;

  // ===================== FIR 数据通道信号 =====================
  wire signed [37:0] dac_data;       // FIR滤波输出（38bit有符号）
  wire        dac_valid;      // FIR输出有效
  reg signed [37:0] dac_data_sat;    // 饱和限幅后的38bit数据

  // ===================== 2MHz 采样分频 =====================
  localparam DECIMATE_FIR = 25;
  localparam START_DELAY = 10;
  reg [7:0] dec_cnt_fir;
  reg [3:0] start_delay_cnt;
  reg        mode_prev;
  wire       mode_switch;
  wire       sample_en_1m;

  always @(posedge FCLK_CLK0) begin
      mode_prev <= adc_bram_mode || fir_dac_mode;
  end
  assign mode_switch = (adc_bram_mode || fir_dac_mode) && !mode_prev;

  always @(posedge FCLK_CLK0) begin
      if(!adc_bram_mode && !fir_dac_mode) begin
          dec_cnt_fir <= 8'd0;
          start_delay_cnt <= 4'd0;
      end
      else if(mode_switch) begin
          dec_cnt_fir <= 8'd0;
          start_delay_cnt <= 4'd0;
      end
      else if(start_delay_cnt < START_DELAY) begin
          start_delay_cnt <= start_delay_cnt + 1'd1;
          dec_cnt_fir <= 8'd0;
      end
      else if(dec_cnt_fir == DECIMATE_FIR - 1)
          dec_cnt_fir <= 8'd0;
      else
          dec_cnt_fir <= dec_cnt_fir + 1'd1;
  end
  assign sample_en_1m = (start_delay_cnt >= START_DELAY) && (dec_cnt_fir == 0);

  // ===================== 饱和限幅逻辑 =====================
  always @(*) begin
      if(dac_data > DAC_DATA_MAX)
          dac_data_sat = DAC_DATA_MAX;
      else if(dac_data < DAC_DATA_MIN)
          dac_data_sat = DAC_DATA_MIN;
      else
          dac_data_sat = dac_data;
  end

  // ===================== BRAM 地址多路选择器 =====================
  always @(*) begin
      if(adc_bram_mode)
          bram_addr = addrb;
      else if(fir_coef_reload_mode)
          bram_addr = addra;
      else
          bram_addr = 17'd0;
  end

  // ===================== DAC 输出多路选择器（14bit适配） =====================
  reg        dac_valid_prev;
  wire       dac_valid_pulse;
  
  always @(posedge FCLK_CLK0) begin
      dac_valid_prev <= dac_valid;
  end
  assign dac_valid_pulse = dac_valid && !dac_valid_prev;

  // FIR: 38bit有符号 → 14bit无符号
  // dac_data_sat范围 ±2^28, 右移14位得 ±16384, 加8192得 0~16384, 钳位到1~16383
  wire signed [13:0] fir_14bit_norm;
  assign fir_14bit_norm = $signed(dac_data_sat[37:14]) + 15'sd8192;

  always @(posedge FCLK_CLK0) begin
      case({fir_dac_mode, dds_mode})
          2'b10: begin // FIR工作模式
              if(!rst_n_fir_synced) begin
                  dac_data_out_reg <= 14'd8192; // FIR复位时输出中点
              end
              else if(dac_valid_pulse) begin
                  // 钳位到[1, 16382]
                  if(fir_14bit_norm <= 14'd0)
                      dac_data_out_reg <= 14'd1;
                  else if(fir_14bit_norm >= 14'd16383)
                      dac_data_out_reg <= 14'd16382;
                  else
                      dac_data_out_reg <= fir_14bit_norm;
              end
          end
          2'b01: begin // DDS模式
              dac_data_out_reg <= dds_dac_out;
          end
          2'b00: begin // 空闲或仅ADC工作模式
              dac_data_out_reg <= 14'd0;
          end
          default: begin // 2'b11：不会出现
              dac_data_out_reg <= 14'd8192;
          end
      endcase
  end

  // ==================================================================================
  // 1. ADC1/2采样 + 写入BRAM（bit0控制）
  // ==================================================================================
  adc_bram_sample adc_bram_sample_inst(
	.clk_bram	    (FCLK_CLK0),
	.rst_n	        (adc_bram_mode),
	.addrb	        (addrb),
	.dinb	        (dinb),
	.web	        (web),
    .adc_data_1     (adc_data_in_1),
    .adc_data_2     (adc_data_in_2),
    .adc_end_flag   (end_adc_flag)
  ); 

  // ==================================================================================
  // 2. BRAM读取系数 + FIR重载（bit1控制）
  // ==================================================================================
  bram_read_fir_reload bram_read_fir_reload_inst(
    .clk_bram       (FCLK_CLK0),
    .rst_n          (fir_coef_reload_mode),
    .addra          (addra),
    .douta          (doutb),
    .s_axis_reload_tvalid (s_axis_reload_tvalid),
    .s_axis_reload_tready (s_axis_reload_tready),
    .s_axis_reload_tlast  (s_axis_reload_tlast),
    .s_axis_reload_tdata  (s_axis_reload_tdata),
    .s_axis_config_tvalid (s_axis_config_tvalid),
    .s_axis_config_tready (s_axis_config_tready),
    .s_axis_config_tdata  (s_axis_config_tdata)
  );

  // ==================================================================================
  // 3. FIR 滤波模块
  // ==================================================================================
  fir_adc12_dac8 fir_adc12_dac8_inst(
    .aclk           (FCLK_CLK0),
    .aresetn        (rst_n_fir_synced),
    .adc_data       (adc_data_in_1),
    .adc_valid      (fir_dac_mode),
    .dac_data       (dac_data),
    .dac_valid      (dac_valid),
    .s_axis_reload_tvalid (s_axis_reload_tvalid),
    .s_axis_reload_tready (s_axis_reload_tready),
    .s_axis_reload_tlast  (s_axis_reload_tlast),
    .s_axis_reload_tdata  (s_axis_reload_tdata),
    .s_axis_config_tvalid (s_axis_config_tvalid),
    .s_axis_config_tready (s_axis_config_tready),
    .s_axis_config_tdata  (s_axis_config_tdata)
  );

  // ==================================================================================
  // 4. DDS模块（bit2控制，14bit输出适配）
  // ==================================================================================
  dds_10hz_2mhz #(
      .PHASE_W  (28),
      .ADDR_W   (11),          // 2048点/波形
      .DATA_W   (14)           // 14bit无符号输出
  ) u_dds (
      .clk        (FCLK_CLK0),
      .rst_n      (dds_mode),
      .freq_word  (dds_ctrl_reg0[27:0]),
      .phase_off  (dds_ctrl_reg1[10:0]),  // 11bit相位偏移
      .wave_sel   (dds_ctrl_reg1[12:11]), // 注意：因ADDR_W增大，wave_sel位置调整
      .amplitude  (dds_ctrl_reg1[20:13]), // 注意：幅度位置偏移
      .dac_out    (dds_dac_out)
  );

  // ==================================================================================
  // 5. BD wrapper
  // ==================================================================================
  design_1_wrapper design_1_wrapper_inst
       (
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .UART_0_1_rxd(UART_0_1_rxd),
        .UART_0_1_txd(UART_0_1_txd),
        .IRQ_F2P_0(end_adc_flag),
        .slv_reg0_o_0(ctrl_start_end_flag),
        .slv_reg1_o_0(dds_ctrl_reg0),
        .slv_reg2_o_0(dds_ctrl_reg1),

	    .FCLK_CLK0_0	(FCLK_CLK0),
	    .addrb_0		({15'd0, bram_addr}),
	    .clkb_0    	(FCLK_CLK0),
	    .dinb_0		(dinb),
	    .doutb_0		(doutb),
	    .enb_0		(1'b1),
	    .web_0		(web)
);

endmodule
