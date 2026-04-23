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
    dac_data,
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

  output [28:0] dac_data;       // FIR滤波输出数据
  // ADC时钟输出
  assign clk_out_adc_1 = FCLK_CLK0;
  assign clk_out_adc_2 = FCLK_CLK0;


  // ===================== 控制信号定义（严格匹配你的注释） =====================
  // ctrl_start_end_flag[0:0] ADC1&ADC2&BRAM写入使能信号  高有效/低复位
  // ctrl_start_end_flag[1:1] FIR系数写入使能信号        高有效/低复位
  // ctrl_start_end_flag[2:2] DAC&DDS扫频输出使能信号     高有效
  // ctrl_start_end_flag[3:3] ADC1&DAC&FIR输出使能信号    高有效/低复位
  wire        FCLK_CLK0;          // PS输出50MHz时钟
  wire [31:0] ctrl_start_end_flag;// PS控制总线
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
  // wire [28:0] dac_data;       // FIR滤波输出
  wire        dac_valid;      // FIR输出有效

  // ===================== BRAM 地址多路选择器（核心：分时读写，互斥无冲突） =====================
  // 规则：仅当【BRAM写使能=1】时，使用写地址；仅当【FIR系数使能=1】时，使用读地址
  always @(*) begin
    if(ctrl_start_end_flag[0])      // 写BRAM模式：ADC1/2写入
        bram_addr = addrb;
    else if(ctrl_start_end_flag[1]) // 读BRAM模式：FIR系数读取
        bram_addr = addra;
    else
        bram_addr = 17'd0;          // 空闲模式：地址归零
  end

  // ==================================================================================
  // 1. 原有验证正常模块：ADC1/2采样 + 写入BRAM（bit0控制）
  // ==================================================================================
  adc_bram_sample adc_bram_sample_inst(
	.clk_bram	    (FCLK_CLK0),                  // 50MHz时钟
	.rst_n	        (ctrl_start_end_flag[0]),     // bit0控制：高工作/低复位
	.addrb	        (addrb),                      // 写地址输出
	.dinb	        (dinb),                       // 写数据输出
	.web	        (web),                        // 写使能输出
    .adc_data_1     (adc_data_in_1),              // ADC1数据
    .adc_data_2     (adc_data_in_2),              // ADC2数据
    .adc_end_flag   (end_adc_flag)               // 采样完成标志
  ); 

  // ==================================================================================
  // 2. 新增模块：BRAM读取系数 + FIR重载（bit1控制）
  // ==================================================================================
  bram_read_fir_reload bram_read_fir_reload_inst(
    .clk_bram       (FCLK_CLK0),                  // 50MHz时钟
    .rst_n          (ctrl_start_end_flag[1]),     // bit1控制：高工作/低复位
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
  // 3. 新增模块：FIR滤波器（bit3控制：ADC1+FIR+DAC模式）
  // ==================================================================================
  fir_adc12_dac8 fir_adc12_dac8_inst(
    .aclk           (FCLK_CLK0),                  // 50MHz时钟
    .aresetn        (ctrl_start_end_flag[3]),     // bit3控制：高工作/低复位
    // 数据通道：仅bit3=1时，ADC1→FIR→DAC
    .adc_data       (adc_data_in_1),              // ADC1数据输入
    .adc_valid      (ctrl_start_end_flag[3]),     // bit3=1时数据有效
    .dac_data       (dac_data),                   // 滤波输出
    .dac_valid      (dac_valid),                  // 输出有效
    // 系数重载通道
    .s_axis_reload_tvalid (s_axis_reload_tvalid),
    .s_axis_reload_tready (s_axis_reload_tready),
    .s_axis_reload_tlast  (s_axis_reload_tlast),
    .s_axis_reload_tdata  (s_axis_reload_tdata),
    .s_axis_config_tvalid (s_axis_config_tvalid),
    .s_axis_config_tready (s_axis_config_tready),
    .s_axis_config_tdata  (s_axis_config_tdata)
  );

  // ==================================================================================
  // 4. 原有BD wrapper（完全不动，仅修改BRAM地址为MUX输出）
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