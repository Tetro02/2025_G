
//------------------------------------------------------------------------------
// (c) Copyright 2023 Advanced Micro Devices. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//------------------------------------------------------------------------------ 
//
// C Model configuration for the "fir_compiler_0" instance.
//
//------------------------------------------------------------------------------
//
// coefficients: -2,10,5,4,4,2,0,-3,-5,-7,-9,-9,-7,-4,0,5,10,14,16,16,13,7,0,-8,-16,-23,-26,-26,-21,-12,0,13,26,36,41,40,33,19,0,-21,-40,-55,-62,-60,-49,-28,0,30,58,80,91,87,70,40,0,-43,-83,-113,-128,-123,-98,-55,0,60,115,156,176,169,134,75,0,-81,-156,-211,-237,-227,-181,-101,0,109,208,282,316,302,240,134,0,-144,-275,-372,-417,-399,-316,-177,0,189,362,490,549,524,416,233,0,-249,-477,-645,-724,-693,-549,-308,0,331,635,861,968,929,739,416,0,-451,-868,-1183,-1337,-1291,-1034,-586,0,645,1254,1727,1974,1931,1568,903,0,-1032,-2051,-2897,-3409,-3447,-2910,-1755,0,2265,4893,7683,10408,12833,14743,15964,16384,15964,14743,12833,10408,7683,4893,2265,0,-1755,-2910,-3447,-3409,-2897,-2051,-1032,0,903,1568,1931,1974,1727,1254,645,0,-586,-1034,-1291,-1337,-1183,-868,-451,0,416,739,929,968,861,635,331,0,-308,-549,-693,-724,-645,-477,-249,0,233,416,524,549,490,362,189,0,-177,-316,-399,-417,-372,-275,-144,0,134,240,302,316,282,208,109,0,-101,-181,-227,-237,-211,-156,-81,0,75,134,169,176,156,115,60,0,-55,-98,-123,-128,-113,-83,-43,0,40,70,87,91,80,58,30,0,-28,-49,-60,-62,-55,-40,-21,0,19,33,40,41,36,26,13,0,-12,-21,-26,-26,-23,-16,-8,0,7,13,16,16,14,10,5,0,-4,-7,-9,-9,-7,-5,-3,0,2,4,4,5,10,-2
// chanpats: 173
// name: fir_compiler_0
// data_coefficient_type: 0
// filter_type: 0
// rate_change: 0
// interp_rate: 1
// decim_rate: 1
// zero_pack_factor: 1
// coeff_padding: 0
// num_coeffs: 301
// coeff_sets: 1
// reloadable: 1
// is_halfband: 0
// quantization: 0
// coeff_width: 16
// coeff_fract_width: 0
// chan_seq: 0
// num_channels: 1
// num_paths: 1
// data_width: 13
// data_fract_width: 0
// output_rounding_mode: 0
// output_width: 38
// accum_width: 38
// output_fract_width: 0
// config_method: 0

const double fir_compiler_0_coefficients[301] = {-2,10,5,4,4,2,0,-3,-5,-7,-9,-9,-7,-4,0,5,10,14,16,16,13,7,0,-8,-16,-23,-26,-26,-21,-12,0,13,26,36,41,40,33,19,0,-21,-40,-55,-62,-60,-49,-28,0,30,58,80,91,87,70,40,0,-43,-83,-113,-128,-123,-98,-55,0,60,115,156,176,169,134,75,0,-81,-156,-211,-237,-227,-181,-101,0,109,208,282,316,302,240,134,0,-144,-275,-372,-417,-399,-316,-177,0,189,362,490,549,524,416,233,0,-249,-477,-645,-724,-693,-549,-308,0,331,635,861,968,929,739,416,0,-451,-868,-1183,-1337,-1291,-1034,-586,0,645,1254,1727,1974,1931,1568,903,0,-1032,-2051,-2897,-3409,-3447,-2910,-1755,0,2265,4893,7683,10408,12833,14743,15964,16384,15964,14743,12833,10408,7683,4893,2265,0,-1755,-2910,-3447,-3409,-2897,-2051,-1032,0,903,1568,1931,1974,1727,1254,645,0,-586,-1034,-1291,-1337,-1183,-868,-451,0,416,739,929,968,861,635,331,0,-308,-549,-693,-724,-645,-477,-249,0,233,416,524,549,490,362,189,0,-177,-316,-399,-417,-372,-275,-144,0,134,240,302,316,282,208,109,0,-101,-181,-227,-237,-211,-156,-81,0,75,134,169,176,156,115,60,0,-55,-98,-123,-128,-113,-83,-43,0,40,70,87,91,80,58,30,0,-28,-49,-60,-62,-55,-40,-21,0,19,33,40,41,36,26,13,0,-12,-21,-26,-26,-23,-16,-8,0,7,13,16,16,14,10,5,0,-4,-7,-9,-9,-7,-5,-3,0,2,4,4,5,10,-2};

const xip_fir_v7_2_pattern fir_compiler_0_chanpats[1] = {P_BASIC};

static xip_fir_v7_2_config gen_fir_compiler_0_config() {
  xip_fir_v7_2_config config;
  config.name                = "fir_compiler_0";
  config.data_coefficient_type = XIP_FIR_REAL_TYPE;
  config.filter_type         = 0;
  config.rate_change         = XIP_FIR_INTEGER_RATE;
  config.interp_rate         = 1;
  config.decim_rate          = 1;
  config.zero_pack_factor    = 1;
  config.coeff               = &fir_compiler_0_coefficients[0];
  config.coeff_padding       = 0;
  config.num_coeffs          = 301;
  config.coeff_sets          = 1;
  config.reloadable          = 1;
  config.is_halfband         = 0;
  config.quantization        = XIP_FIR_INTEGER_COEFF;
  config.coeff_width         = 16;
  config.coeff_fract_width   = 0;
  config.chan_seq            = XIP_FIR_BASIC_CHAN_SEQ;
  config.num_channels        = 1;
  config.init_pattern        = fir_compiler_0_chanpats[0];
  config.num_paths           = 1;
  config.data_width          = 13;
  config.data_fract_width    = 0;
  config.output_rounding_mode= XIP_FIR_FULL_PRECISION;
  config.output_width        = 38;
  config.accum_width         = 38;
  config.output_fract_width  = 0;
  config.config_method       = XIP_FIR_CONFIG_SINGLE;
  return config;
}

const xip_fir_v7_2_config fir_compiler_0_config = gen_fir_compiler_0_config();

