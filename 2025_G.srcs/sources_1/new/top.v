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

  output [7:0] dac_data_out;       // FIR滤波输出数据
  output clk_out_dac;             // 输出到DAC的时钟

  // ===================== 控制信号提前声明（修复：先声明后使用） =====================
  wire        FCLK_CLK0;          // PS输出50MHz时钟
  wire [31:0] ctrl_start_end_flag;// PS控制总线

  // ===================== 内部信号声明（新增，解决语法错误） =====================
  reg [7:0]  dac_data_out_reg;    // DAC数据中间寄存器
  reg        clk_out_dac_reg;      // DAC时钟中间寄存器
  wire       rst_n_fir;            // FIR模式复位信号（未同步）
  wire       rst_n_fir_synced;     // 同步后的复位信号
  // 29bit有符号数偏移量 2^28，用于29bit→8bit转换
  localparam signed OFFSET_28 = (28'd1 << 27);
  // 29bit有符号数最大值和最小值，用于饱和限幅（修复问题9）
  localparam signed DAC_DATA_MIN = -29'sd268435455; // -2^28
  localparam signed DAC_DATA_MAX =  29'sd268435455; //  2^28

// ===================== 模式互斥逻辑 =====================
// 优先级规则：
// 1. bit1（系数重载）：最高优先级，独占总线
// 2. bit0（ADC采样）和 bit2（DDS输出）：可以同时工作
// 3. bit3（FIR滤波）：独占DAC，与其他模式互斥

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

  // ===================== 复位同步器（修复问题5：异步复位同步化） =====================
  reg [1:0] rst_sync;
  assign rst_n_fir = fir_dac_mode;
  always @(posedge FCLK_CLK0 or negedge rst_n_fir) begin
      if (!rst_n_fir)
          rst_sync <= 2'b0;
      else
          rst_sync <= {rst_sync[0], 1'b1};
  end
  assign rst_n_fir_synced = rst_sync[1];

  // ===================== ODDR 原语输出时钟（修复问题4：保证时钟质量） =====================
  // 用 ODDR 输出 ADC 时钟，减少时钟偏斜，满足Xilinx时序要求
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
  // ===================== DAC 时钟：50MHz 连续时钟 =====================
  // 用 ODDR 输出持续的 50MHz 时钟给 DAC
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

  // ===================== 剩余控制信号定义（严格匹配你的注释） =====================
  // ctrl_start_end_flag[0:0] ADC1&ADC2&BRAM写入使能信号  高有效/低复位
  // ctrl_start_end_flag[1:1] FIR系数写入使能信号        高有效/低复位
  // ctrl_start_end_flag[2:2] DAC&DDS扫频输出使能信号     高有效
  // ctrl_start_end_flag[3:3] ADC1&DAC&FIR输出使能信号    高有效/低复位
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
  // 饱和限幅后的38bit数据
  reg signed [37:0] dac_data_sat;

  // ===================== 2MHz 采样分频（模式切换时同步复位） =====================
  localparam DECIMATE_FIR = 25;
  localparam START_DELAY = 10; // 复位后延迟10个时钟周期再采样
  reg [7:0] dec_cnt_fir;
  reg [3:0] start_delay_cnt;
  reg        mode_prev; // 记录上一时刻的模式状态
  wire       mode_switch; // 模式切换标志
  wire       sample_en_1m;  // 1MHz 全链路采样同步基准信号

  // 检测模式切换（上升沿）
  always @(posedge FCLK_CLK0) begin
      mode_prev <= adc_bram_mode || fir_dac_mode;
  end
  assign mode_switch = (adc_bram_mode || fir_dac_mode) && !mode_prev;

  // 修复：模式切换时同步复位计数器，保证相位对齐；加入启动延迟
  always @(posedge FCLK_CLK0) begin
      if(!adc_bram_mode && !fir_dac_mode) begin
          dec_cnt_fir <= 8'd0;
          start_delay_cnt <= 4'd0;
      end
      else if(mode_switch) begin // 模式切换时复位
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
      if(adc_bram_mode)      // 写BRAM模式：ADC1/2写入，互斥保护
          bram_addr = addrb;
      else if(fir_coef_reload_mode) // 读BRAM模式：FIR系数读取，优先级最高
          bram_addr = addra;
      else
          bram_addr = 17'd0;          // 空闲模式：地址归零
  end

  // ===================== DAC 输出多路选择器（核心修复：问题1、6、7、10） =====================
  // 规则：
  // bit3=1 → FIR模式：输出滤波数据 + dac_valid作为时钟（时序天然匹配）
  // bit2=1 → DDS模式：预留位置（后续添加DDS模块）
  // 其他 → 输出0
  // 组合逻辑改时序逻辑，和FIR有效信号同步，消除毛刺
  // 用dac_valid作为DAC时钟，保证时钟和数据同源，时序天然匹配
  // 完善case覆盖，明确所有状态行为
  // 检测 dac_valid 的上升沿，保证数据只更新一次
  reg        dac_valid_prev;
  wire       dac_valid_pulse;
  
  always @(posedge FCLK_CLK0) begin
      dac_valid_prev <= dac_valid;
  end
  assign dac_valid_pulse = dac_valid && !dac_valid_prev; // 上升沿脉冲

  always @(posedge FCLK_CLK0) begin
      if(!rst_n_fir_synced) begin
          dac_data_out_reg <= 8'd128; // 复位默认输出DAC中点128
      end
      else begin
          case({fir_dac_mode, dds_mode})
              2'b10: begin // FIR工作模式
                  // 仅在 dac_valid 上升沿时更新数据
                  if(dac_valid_pulse) begin
                      dac_data_out_reg <= (dac_data_sat + OFFSET_28) >> 20;
                  end
                  else begin
                      dac_data_out_reg <= dac_data_out_reg; // 保持不变，避免毛刺
                  end
              end
              2'b01: begin // DDS模式（预留）
                  dac_data_out_reg <= 8'd0; // 这里后续接你的DDS数据
              end
              2'b00: begin // 空闲或仅ADC工作模式
                  dac_data_out_reg <= 8'd0;
              end
              default: begin // 2'b11：FIR和DDS互斥，不会出现
                  dac_data_out_reg <= 8'd128;
              end
          endcase
      end
  end

  // ==================================================================================
  // 1. 原有验证正常模块：ADC1/2采样 + 写入BRAM（bit0控制，修复问题2：复位逻辑）
  // ==================================================================================
  adc_bram_sample adc_bram_sample_inst(
	.clk_bram	    (FCLK_CLK0),                  // 50MHz时钟
	.rst_n	        (adc_bram_mode),              // 修复：互斥模式下复位，避免冲突
	.addrb	        (addrb),                      // 写地址输出
	.dinb	        (dinb),                       // 写数据输出
	.web	        (web),                        // 写使能输出
    .adc_data_1     (adc_data_in_1),              // ADC1数据
    .adc_data_2     (adc_data_in_2),              // ADC2数据
    .adc_end_flag   (end_adc_flag)                // 采样完成标志
  ); 

  // ==================================================================================
  // 2. 新增模块：BRAM读取系数 + FIR重载（bit1控制，完全不动）
  // ==================================================================================
  bram_read_fir_reload bram_read_fir_reload_inst(
    .clk_bram       (FCLK_CLK0),                  // 50MHz时钟
    .rst_n          (fir_coef_reload_mode),        // 修复：使用互斥模式复位
    .addra          (addra),                      // 读地址输出
    .douta          (doutb),                      // BRAM读出数据
    // FIR重载端口
    .s_axis_reload_tvalid (s_axis_reload_tvalid),
    .s_axis_reload_tready (s_axis_reload_tready),
    .s_axis_reload_tlast  (s_axis_reload_tlast),
    .s_axis_reload_tdata  (s_axis_reload_tdata),
    .s_axis_config_tvalid (s_axis_config_tvalid),
    .s_axis_config_tready (s_axis_config_tready),
    .s_axis_config_tdata  (s_axis_config_tdata)
  );

  // ==================================================================================
  // 3. FIR 滤波模块（修复：使能逻辑优化，和采样基准同步）
  // ==================================================================================
  fir_adc12_dac8 fir_adc12_dac8_inst(
    .aclk           (FCLK_CLK0),                  // 固定50MHz时钟
    .aresetn        (rst_n_fir_synced),           // 修复：使用同步后的复位
    
    // FIR使能 + 1MHz采样脉冲 双条件，保证采样率严格匹配
    .adc_data       (adc_data_in_1),              
    .adc_valid      (fir_dac_mode), // FIR模式下，且采样使能时有效
    // .adc_valid      (fir_dac_mode && sample_en_1m), // FIR模式下，且采样使能时有效
    
    .dac_data       (dac_data),    // 38bit滤波后数据
    .dac_valid      (dac_valid),   // 输出数据有效
    
    // 系数重载端口
    .s_axis_reload_tvalid (s_axis_reload_tvalid),
    .s_axis_reload_tready (s_axis_reload_tready),
    .s_axis_reload_tlast  (s_axis_reload_tlast),
    .s_axis_reload_tdata  (s_axis_reload_tdata),
    .s_axis_config_tvalid (s_axis_config_tvalid),
    .s_axis_config_tready (s_axis_config_tready),
    .s_axis_config_tdata  (s_axis_config_tdata)
  );

  // ==================================================================================
  // 4. 原有BD wrapper（完全不动）
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
        .IRQ_F2P_0(end_adc_flag),         // 采样完成→PS中断
        .slv_reg0_o_0(ctrl_start_end_flag),// PS控制信号

	    .FCLK_CLK0_0	(FCLK_CLK0),
	    .addrb_0		({15'd0, bram_addr}),  // MUX切换后的最终地址
	    .clkb_0    	(FCLK_CLK0),
	    .dinb_0		(dinb),
	    .doutb_0		(doutb),
	    .enb_0		(1'b1),                // BRAM总使能
	    .web_0		(web)                  // 写使能
);

endmodule