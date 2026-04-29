
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
// coefficients: 0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,0,0,0,0,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-1,-1,0,0,0,1,1,2,2,3,4,4,5,5,6,6,7,7,8,8,8,9,9,10,10,10,10,11,11,11,11,11,11,11,11,11,11,10,10,10,9,9,8,8,7,7,6,5,4,4,3,2,1,0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-17,-18,-19,-19,-20,-20,-21,-21,-21,-21,-21,-21,-21,-21,-21,-20,-20,-19,-18,-18,-17,-16,-15,-14,-12,-11,-10,-8,-7,-5,-3,-2,0,2,4,5,7,9,11,13,15,17,19,20,22,24,26,27,29,30,31,33,34,35,36,36,37,38,38,38,38,38,38,37,37,36,35,34,33,31,30,28,26,24,22,20,17,15,12,9,6,3,0,-3,-6,-10,-13,-16,-20,-23,-26,-30,-33,-36,-39,-42,-45,-48,-50,-53,-55,-58,-60,-61,-63,-64,-65,-66,-67,-67,-68,-67,-67,-66,-65,-64,-62,-61,-58,-56,-53,-50,-47,-43,-39,-35,-31,-26,-21,-16,-11,-6,0,6,12,18,24,30,36,42,48,55,61,67,73,78,84,89,95,100,104,109,113,117,120,123,126,128,130,131,132,132,132,131,130,128,125,122,118,114,109,103,97,90,83,74,66,56,46,35,24,12,0,-13,-26,-40,-55,-70,-85,-101,-117,-133,-150,-167,-184,-202,-219,-237,-255,-273,-291,-309,-326,-344,-362,-379,-397,-414,-430,-447,-463,-478,-493,-508,-522,-535,-548,-561,-572,-583,-594,-603,-612,-620,-628,-634,-640,-644,-648,-651,-654,-655,32113,-655,-654,-651,-648,-644,-640,-634,-628,-620,-612,-603,-594,-583,-572,-561,-548,-535,-522,-508,-493,-478,-463,-447,-430,-414,-397,-379,-362,-344,-326,-309,-291,-273,-255,-237,-219,-202,-184,-167,-150,-133,-117,-101,-85,-70,-55,-40,-26,-13,0,12,24,35,46,56,66,74,83,90,97,103,109,114,118,122,125,128,130,131,132,132,132,131,130,128,126,123,120,117,113,109,104,100,95,89,84,78,73,67,61,55,48,42,36,30,24,18,12,6,0,-6,-11,-16,-21,-26,-31,-35,-39,-43,-47,-50,-53,-56,-58,-61,-62,-64,-65,-66,-67,-67,-68,-67,-67,-66,-65,-64,-63,-61,-60,-58,-55,-53,-50,-48,-45,-42,-39,-36,-33,-30,-26,-23,-20,-16,-13,-10,-6,-3,0,3,6,9,12,15,17,20,22,24,26,28,30,31,33,34,35,36,37,37,38,38,38,38,38,38,37,36,36,35,34,33,31,30,29,27,26,24,22,20,19,17,15,13,11,9,7,5,4,2,0,-2,-3,-5,-7,-8,-10,-11,-12,-14,-15,-16,-17,-18,-18,-19,-20,-20,-21,-21,-21,-21,-21,-21,-21,-21,-21,-20,-20,-19,-19,-18,-17,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,4,5,6,7,7,8,8,9,9,10,10,10,11,11,11,11,11,11,11,11,11,11,10,10,10,10,9,9,8,8,8,7,7,6,6,5,5,4,4,3,2,2,1,1,0,0,0,-1,-1,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0
// chanpats: 173
// name: fir_compiler_0
// data_coefficient_type: 0
// filter_type: 0
// rate_change: 0
// interp_rate: 1
// decim_rate: 1
// zero_pack_factor: 1
// coeff_padding: 1
// num_coeffs: 801
// coeff_sets: 1
// reloadable: 1
// is_halfband: 0
// quantization: 0
// coeff_width: 16
// coeff_fract_width: 0
// chan_seq: 0
// num_channels: 1
// num_paths: 1
// data_width: 12
// data_fract_width: 0
// output_rounding_mode: 0
// output_width: 38
// accum_width: 38
// output_fract_width: 0
// config_method: 0

const double fir_compiler_0_coefficients[801] = {0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,0,0,0,0,0,-1,-1,-1,-1,-2,-2,-2,-2,-3,-3,-3,-3,-3,-4,-4,-4,-4,-4,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-3,-3,-3,-3,-2,-2,-1,-1,0,0,0,1,1,2,2,3,4,4,5,5,6,6,7,7,8,8,8,9,9,10,10,10,10,11,11,11,11,11,11,11,11,11,11,10,10,10,9,9,8,8,7,7,6,5,4,4,3,2,1,0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16,-17,-17,-18,-19,-19,-20,-20,-21,-21,-21,-21,-21,-21,-21,-21,-21,-20,-20,-19,-18,-18,-17,-16,-15,-14,-12,-11,-10,-8,-7,-5,-3,-2,0,2,4,5,7,9,11,13,15,17,19,20,22,24,26,27,29,30,31,33,34,35,36,36,37,38,38,38,38,38,38,37,37,36,35,34,33,31,30,28,26,24,22,20,17,15,12,9,6,3,0,-3,-6,-10,-13,-16,-20,-23,-26,-30,-33,-36,-39,-42,-45,-48,-50,-53,-55,-58,-60,-61,-63,-64,-65,-66,-67,-67,-68,-67,-67,-66,-65,-64,-62,-61,-58,-56,-53,-50,-47,-43,-39,-35,-31,-26,-21,-16,-11,-6,0,6,12,18,24,30,36,42,48,55,61,67,73,78,84,89,95,100,104,109,113,117,120,123,126,128,130,131,132,132,132,131,130,128,125,122,118,114,109,103,97,90,83,74,66,56,46,35,24,12,0,-13,-26,-40,-55,-70,-85,-101,-117,-133,-150,-167,-184,-202,-219,-237,-255,-273,-291,-309,-326,-344,-362,-379,-397,-414,-430,-447,-463,-478,-493,-508,-522,-535,-548,-561,-572,-583,-594,-603,-612,-620,-628,-634,-640,-644,-648,-651,-654,-655,32113,-655,-654,-651,-648,-644,-640,-634,-628,-620,-612,-603,-594,-583,-572,-561,-548,-535,-522,-508,-493,-478,-463,-447,-430,-414,-397,-379,-362,-344,-326,-309,-291,-273,-255,-237,-219,-202,-184,-167,-150,-133,-117,-101,-85,-70,-55,-40,-26,-13,0,12,24,35,46,56,66,74,83,90,97,103,109,114,118,122,125,128,130,131,132,132,132,131,130,128,126,123,120,117,113,109,104,100,95,89,84,78,73,67,61,55,48,42,36,30,24,18,12,6,0,-6,-11,-16,-21,-26,-31,-35,-39,-43,-47,-50,-53,-56,-58,-61,-62,-64,-65,-66,-67,-67,-68,-67,-67,-66,-65,-64,-63,-61,-60,-58,-55,-53,-50,-48,-45,-42,-39,-36,-33,-30,-26,-23,-20,-16,-13,-10,-6,-3,0,3,6,9,12,15,17,20,22,24,26,28,30,31,33,34,35,36,37,37,38,38,38,38,38,38,37,36,36,35,34,33,31,30,29,27,26,24,22,20,19,17,15,13,11,9,7,5,4,2,0,-2,-3,-5,-7,-8,-10,-11,-12,-14,-15,-16,-17,-18,-18,-19,-20,-20,-21,-21,-21,-21,-21,-21,-21,-21,-21,-20,-20,-19,-19,-18,-17,-17,-16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,4,5,6,7,7,8,8,9,9,10,10,10,11,11,11,11,11,11,11,11,11,11,10,10,10,10,9,9,8,8,8,7,7,6,6,5,5,4,4,3,2,2,1,1,0,0,0,-1,-1,-2,-2,-3,-3,-3,-3,-4,-4,-4,-4,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-5,-4,-4,-4,-4,-4,-3,-3,-3,-3,-3,-2,-2,-2,-2,-1,-1,-1,-1,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,0,0,0,0};

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
  config.coeff_padding       = 1;
  config.num_coeffs          = 801;
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
  config.data_width          = 12;
  config.data_fract_width    = 0;
  config.output_rounding_mode= XIP_FIR_FULL_PRECISION;
  config.output_width        = 38;
  config.accum_width         = 38;
  config.output_fract_width  = 0;
  config.config_method       = XIP_FIR_CONFIG_SINGLE;
  return config;
}

const xip_fir_v7_2_config fir_compiler_0_config = gen_fir_compiler_0_config();

