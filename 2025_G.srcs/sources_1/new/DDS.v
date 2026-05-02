`timescale 1ns / 1ps
module dds_10hz_2mhz
#(
    parameter PHASE_W   = 28,
    parameter ADDR_W    = 11,            // 2^11 = 2048个采样点/波形
    parameter DATA_W    = 14             // 14bit无符号DAC输出
)
(
    input                   clk,
    input                   rst_n,
    input  [PHASE_W-1:0]    freq_word,    // PS控制：频率
    input  [ADDR_W-1:0]     phase_off,    // PS控制：相位
    input  [1:0]            wave_sel,     // PS控制：波形
    input  [7:0]            amplitude,    // PS控制：幅度 0~255
    output [DATA_W-1:0]     dac_out       // 无直流分量，14bit，中点8192
);

// 相位累加器
reg [PHASE_W-1:0] phase_acc;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        phase_acc <= 0;
    else
        phase_acc <= phase_acc + freq_word;
end

// 相位偏移（取高 ADDR_W bit 作为波形ROM地址）
wire [ADDR_W-1:0] base_addr = phase_acc[PHASE_W-1 -: ADDR_W];
wire [ADDR_W-1:0] final_addr = base_addr + phase_off;

// 波形ROM地址：{wave_sel[1:0], final_addr[10:0]} → 13bit可寻址8192深度
wire [12:0] rom_addr = {wave_sel, final_addr};

// ROM读出原始无符号波形 (0~16383, 中点8192)
wire [13:0] wave_raw;
wave_rom rom_inst (
  .clka(clk),
  .addra(rom_addr),
  .douta(wave_raw)
);

// ===================== 幅度缩放 — 四舍五入 + 钳位 =====================
// 1. 无符号转有符号：减去中点8192，范围 -8192 ~ 8191
wire signed [14:0] wave_signed = $signed({1'b0, wave_raw}) - 15'sd8192;

// 2. 有符号数 × 幅度（保持0点不变）
reg signed [22:0] wave_mult;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        wave_mult <= 23'd0;
    else
        wave_mult <= wave_signed * $signed({7'b0, amplitude}); // 15bit × 8bit = 23bit
end

// 3. 归一化（右移8位，四舍五入）+ 恢复中点8192
//    ★ 钳位到[1,16382]，保证DAC输出永远不出现0x0000或0x3FFF ★
wire signed [22:0] wave_mult_rnd = wave_mult + 23'sd128;
wire signed [14:0] wave_norm = $signed(wave_mult_rnd[22:8]) + 15'sd8192;

wire [13:0] wave_scaled;
assign wave_scaled = (wave_norm[14:0] <= 15'd0)         ? 14'd1 :     // 钳位Vmin
                     (wave_norm[14:0] >= 15'd16383)      ? 14'd16382 : // 钳位Vmax
                     wave_norm[13:0];

// 最终输出
assign dac_out = wave_scaled;
// ======================================================================

endmodule
