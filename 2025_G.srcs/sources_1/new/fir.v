module fir_adc12_dac8(
    input  wire         aclk,
    input  wire         aresetn,

    // ADC 数据输入
    input  wire [11:0]  adc_data,
    input  wire         adc_valid,

    // DAC 数据输出
    output wire [28:0]  dac_data,
    output wire         dac_valid,

    // ---------------- 新增：FIR 系数重载端口 ----------------
    input  wire         s_axis_reload_tvalid,
    output wire         s_axis_reload_tready,
    input  wire         s_axis_reload_tlast,
    input  wire [15:0]  s_axis_reload_tdata,

    input  wire         s_axis_config_tvalid,
    output wire         s_axis_config_tready,
    input  wire [7:0]   s_axis_config_tdata
    // --------------------------------------------------------

    // 可选：异常事件输出（调试用）
    // output wire         event_tlast_missing,
    // output wire         event_tlast_unexpected
);

    // =========================================================
    // 1. ADC：0~4095 → signed centered (-2048 ~ +2047)
    // =========================================================
    wire signed [11:0] adc_signed;
    assign adc_signed = $signed(adc_data) - 12'sd2048;

    // =========================================================
    // 2. 扩展到 FIR 输入位宽（16bit）
    // =========================================================
    wire signed [15:0] fir_in;
    assign fir_in = {{4{adc_signed[11]}}, adc_signed};

    // =========================================================
    // 3. FIR IP 例化（完整端口）
    // =========================================================
    fir_compiler_0 u_fir (
        .aresetn                        (aresetn),
        .aclk                           (aclk),

        // 数据通道
        .s_axis_data_tvalid             (adc_valid),
        .s_axis_data_tready             (),
        .s_axis_data_tdata              (fir_in),

        // 重载通道（由外部TB控制）
        .s_axis_reload_tvalid           (s_axis_reload_tvalid),
        .s_axis_reload_tready           (s_axis_reload_tready),
        .s_axis_reload_tlast            (s_axis_reload_tlast),
        .s_axis_reload_tdata            (s_axis_reload_tdata),

        // 配置通道（由外部TB控制）
        .s_axis_config_tvalid           (s_axis_config_tvalid),
        .s_axis_config_tready           (s_axis_config_tready),
        .s_axis_config_tdata            (s_axis_config_tdata),

        // 数据输出
        .m_axis_data_tvalid             (dac_valid),
        .m_axis_data_tdata              (dac_data)

        // 异常事件
        // .event_s_reload_tlast_missing   (event_tlast_missing),
        // .event_s_reload_tlast_unexpected(event_tlast_unexpected)
    );

endmodule