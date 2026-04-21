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
    adc_data_in_2
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

  assign clk_out_adc_1 = FCLK_CLK0; // 直接使用PS时钟输出给ADC
  assign clk_out_adc_2 = FCLK_CLK0; // 直接使用PS时钟输出给ADC

  // BRAM 接口信号线
  wire [31:0] addrb;   // BRAM 地址
  wire [31:0] doutb;   // BRAM 读出数据
  wire [31:0] dinb;    // 写入BRAM数据(ADC采样值)
  wire [3:0]  web;     // BRAM 写使能
  wire        FCLK_CLK0; // PS输出时钟
  wire        start_adc_flag;// 从PS传来的开始采集标志
  wire        end_adc_flag;  // 采集完成标志
  
// ===================== 替换为：模拟ADC采集1024点写入BRAM =====================
adc_bram_sample adc_bram_sample_inst(
	.clk_bram	(FCLK_CLK0),     // BRAM工作时钟
	.rst_n	    (start_adc_flag),          // 复位：高电平不复位
	.addrb	    (addrb[16:0]),    // 17位地址(0~131071)，兼容32位端口
	.dinb	    (dinb),          // ADC采样数据 → 写入BRAM
	.web	    (web),            // 写使能信号
  .adc_data_1   (adc_data_in_1),    // 模拟ADC输入数据
  .adc_data_2   (adc_data_in_2),    // 模拟ADC输入数据
  .adc_end_flag(end_adc_flag)
); 

// ===================== 原有BD wrapper 完全不变 =====================
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
        .IRQ_F2P_0(end_adc_flag), // 采集完成标志连接到PS中断
        .slv_reg0_o_0(start_adc_flag),

	.FCLK_CLK0_0	(FCLK_CLK0),
	.addrb_0		(addrb[31:0]),
	.clkb_0    	(FCLK_CLK0),
	.dinb_0		(dinb [31:0]),
	.doutb_0		(doutb[31:0]),
	.enb_0		(1'b1),          // BRAM 总使能
	.web_0		(web  [3:0] )
);

endmodule