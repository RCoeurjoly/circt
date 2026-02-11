// REQUIRES: yosys
// RUN: circt-opt %s \
// RUN:   -handshake-materialize-forks-sinks \
// RUN:   -lower-handshake-to-hw \
// RUN:   -lower-esi-to-physical \
// RUN:   -lower-esi-ports \
// RUN:   -lower-esi-to-hw \
// RUN:   -lower-seq-to-sv \
// RUN:   -lower-verif-to-sv \
// RUN:   -canonicalize \
// RUN:   -export-verilog -o %t.lowered.mlir > %t.sv
// RUN: not grep -E "\\$itor|\\$bitstoshortreal|\\$shortrealtobits|\\$bitstoreal|\\$realtobits|\\breal\\b|\\bshortreal\\b" %t.sv
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top test_fp_binary_math; stat"

handshake.func @test_fp_binary_math(%ctrl: none, ...) -> (f32, f32, f32, f32, i1, i1) {
  %f:2 = fork [2] %ctrl : none
  %a = constant %f#0 {value = 2.250000e+00 : f32} : f32
  %b = constant %f#1 {value = 5.000000e-01 : f32} : f32
  %af:5 = fork [5] %a : f32
  %bf:6 = fork [6] %b : f32
  %atan2 = math.atan2 %af#0, %bf#0 : f32
  %powf = math.powf %af#1, %bf#1 : f32
  %fma = math.fma %af#2, %bf#2, %bf#3 : f32
  %cpy = math.copysign %af#3, %bf#4 : f32
  %isf = math.isfinite %af#4 : f32
  %isn = math.isnan %bf#5 : f32
  return %atan2, %powf, %fma, %cpy, %isf, %isn : f32, f32, f32, f32, i1, i1
}
