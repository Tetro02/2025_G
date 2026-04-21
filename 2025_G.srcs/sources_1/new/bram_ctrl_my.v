module adc_bram_sample(
    input         clk_bram,   // 50MHz
    input         rst_n,      // 低电平复位

    input  [11:0] adc_data_1,   // AD9226输出
    input  [11:0] adc_data_2,   // AD9226输出
    output reg [16:0] addrb,
    output reg [31:0] dinb,
    output reg [3:0]  web,
    output reg        adc_end_flag
);

// ===================== 参数 =====================
localparam SAMPLE_MAX = 12'd4095;  // 4096个点 (0~4095)
localparam DECIMATE   = 167;       // 抽取比

// ===================== 抽取计数器 =====================
reg [7:0] dec_cnt;
wire sample_en;

always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n)
        dec_cnt <= 8'd0;
    else if(dec_cnt == DECIMATE-1)
        dec_cnt <= 8'd0;
    else
        dec_cnt <= dec_cnt + 1'd1;
end

assign sample_en = (dec_cnt == 0);

// ===================== 采样计数器 + 完成标志（完全正确，不动） =====================
reg [11:0] sample_cnt;

always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n) begin
        sample_cnt   <= 12'd0;
        adc_end_flag <= 1'b0;
    end
    // 未采满：计数+1
    else if (sample_en && sample_cnt < SAMPLE_MAX) begin
        sample_cnt   <= sample_cnt + 1'd1;
        adc_end_flag <= 1'b0;
    end
    // 采满：置位完成标志
    else if (sample_en && sample_cnt == SAMPLE_MAX) begin
        adc_end_flag <= 1'b1;
    end
end

// ===================== 写BRAM =====================
always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n) begin
        addrb <= 17'd0;
        dinb  <= 32'd0;
        web   <= 4'b0000;
    end
    // 核心正确条件：采集中（未完成） + 采样使能 → 写入
    else if(sample_en && !adc_end_flag) begin
        addrb <= sample_cnt * 4;  // 字节地址：32位数据 = 4字节
        dinb  <= {4'd0, adc_data_1, 4'd0, adc_data_2}; // 高16位：adc_data_1，低16位：adc_data_2
        web   <= 4'b1111;         // 写使能
    end
    else begin
        web   <= 4'b0000;         // 其余时间禁止写入
    end
end

endmodule