module bram_read_fir_reload(
    input         clk_bram,   // 50MHz 时钟
    input         rst_n,      // 低电平复位

    // BRAM 读接口（和你的模块完全一样）
    output reg [16:0] addra,
    input      [31:0] douta,

    // FIR 系数重载端口
    output reg        s_axis_reload_tvalid,
    input             s_axis_reload_tready,
    output reg        s_axis_reload_tlast,
    output reg [15:0] s_axis_reload_tdata,

    output reg        s_axis_config_tvalid,
    input             s_axis_config_tready,
    output reg [7:0]  s_axis_config_tdata
);

// ===================== 参数 =====================
localparam START_ADDR     = 17'd16400;  // 4100 * 4
localparam COEFF_CNT_MAX  = 8'd150;     // 151个系数 (0~150)

// ===================== 系数计数器 =====================
reg [7:0] coeff_cnt;

always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n)
        coeff_cnt <= 8'd0;
    // 握手成功才计数 +1
    else if (s_axis_reload_tvalid && s_axis_reload_tready && coeff_cnt <= COEFF_CNT_MAX)
        coeff_cnt <= coeff_cnt + 1'd1;
end

// ===================== 读 BRAM 地址 =====================
always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n)
        addra <= START_ADDR;
    // 每成功读一个，地址 +4（32bit 对齐）
    else if (s_axis_reload_tvalid && s_axis_reload_tready)
        addra <= addra + 17'd4;
end

// ===================== FIR 重载通道控制 =====================
always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n) begin
        s_axis_reload_tvalid <= 1'b0;
        s_axis_reload_tlast  <= 1'b0;
        s_axis_reload_tdata  <= 16'd0;
    end
    // 复位后一直发送，直到 151 个发完
    else if (coeff_cnt <= COEFF_CNT_MAX) begin
        s_axis_reload_tvalid <= 1'b1;
        s_axis_reload_tdata  <= douta[31:16];  // 取高16bit作为系数
        s_axis_reload_tlast  <= (coeff_cnt == COEFF_CNT_MAX);
    end
    else begin
        s_axis_reload_tvalid <= 1'b0;
        s_axis_reload_tlast  <= 1'b0;
    end
end

// ===================== FIR 配置生效 =====================
always @(posedge clk_bram or negedge rst_n) begin
    if(!rst_n) begin
        s_axis_config_tvalid <= 1'b0;
        s_axis_config_tdata  <= 8'd0;
    end
    // 151 个系数发完 → 自动生效
    else if (coeff_cnt == COEFF_CNT_MAX + 1) begin
        s_axis_config_tvalid <= 1'b1;
        s_axis_config_tdata  <= 8'd1;
    end
    // 握手完成后拉低
    else if (s_axis_config_tvalid && s_axis_config_tready) begin
        s_axis_config_tvalid <= 1'b0;
    end
end

endmodule