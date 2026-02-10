// REQUIRES: yosys
// RUN: circt-opt %s -export-verilog -o %t.lowered.mlir > %t.sv
// RUN: not grep -E "module \\{|hw\\.module|\\breal\\b|\\bshortreal\\b|\\$itor|\\$exp|\\$pow|\\$sqrt" %t.sv
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top top; stat"

hw.module.extern @circt_fp_addf_f32(in %in0: f32, in %in1: f32, out out0: f32) attributes {sv.attributes = [#sv.attribute<"blackbox">]}

hw.module @top(in %a: f32, in %b: f32, out y: f32) {
  %u.out0 = hw.instance "u_fp" @circt_fp_addf_f32(in0: %a: f32, in1: %b: f32) -> (out0: f32)
  hw.output %u.out0 : f32
}
