`timescale 1ns / 1ps
module dds_10hz_2mhz
#(
    parameter PHASE_W   = 28,
    parameter ADDR_W    = 10,
    parameter DATA_W    = 8
)
(
    input                   clk,
    input                   rst_n,
    input  [PHASE_W-1:0]    freq_word,    // PS控制：频率
    input  [ADDR_W-1:0]     phase_off,    // PS控制：相位
    input  [1:0]            wave_sel,     // PS控制：波形
    input  [7:0]            amplitude,    // PS控制：幅度 0~255
    output [DATA_W-1:0]     dac_out       // 无直流分量，中点128
);

// 相位累加器
reg [PHASE_W-1:0] phase_acc;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        phase_acc <= 0;
    else
        phase_acc <= phase_acc + freq_word;
end

// 相位偏移
wire [ADDR_W-1:0] base_addr = phase_acc[PHASE_W-1 -: ADDR_W];
wire [ADDR_W-1:0] final_addr = base_addr + phase_off;

// 波形ROM地址
wire [11:0] rom_addr = {wave_sel, final_addr};

// ROM读出原始无符号波形 (0~255, 中点128)
wire [7:0] wave_raw;
wave_rom rom_inst (
  .clka(clk),
  .addra(rom_addr),
  .douta(wave_raw)
);

// ===================== 幅度缩放 — 四舍五入 + 钳位到[1,254]避免Vmin/Vmax =====================
// 1. 无符号转有符号：减去中点128，范围 -128 ~ 127（交流0点对齐）
wire signed [7:0]  wave_signed = wave_raw - 8'd128;

// 2. 有符号数 × 幅度（保持0点不变）
reg signed [15:0] wave_mult;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        wave_mult <= 16'd0;
    else
        wave_mult <= wave_signed * $signed({1'b0, amplitude}); // 无符号幅度转有符号计算
end

// 3. 归一化（右移8位）+ 恢复中点128
//    ★ 使用四舍五入(+128)而非截断，避免波谷被切到0（Vmin）★
//    ★ 钳位到[1,254]，保证DAC输出永远不出现0x00或0xFF ★
wire [7:0] wave_scaled_round = ((wave_mult + 16'sd128) >>> 8) + 8'd128;
wire [7:0] wave_scaled;
assign wave_scaled = (wave_scaled_round == 8'd0)   ? 8'd1 :   // 钳位Vmin
                     (wave_scaled_round == 8'd255) ? 8'd254 : // 钳位Vmax
                     wave_scaled_round;

// 最终输出
assign dac_out = wave_scaled;
// ======================================================================

endmodule
