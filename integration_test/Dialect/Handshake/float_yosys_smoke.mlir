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
// RUN: not grep -E "\\$itor|\\$bitstoshortreal|\\$shortrealtobits|\\$bitstoreal|\\$realtobits|\\$exp|\\$sqrt|\\$pow|\\breal\\b|\\bshortreal\\b" %t.sv
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top test_fp; stat"

handshake.func @test_fp(%ctrl: none, ...) -> (f32, i1) {
  %f:2 = fork [2] %ctrl : none
  %c0 = constant %f#0 {value = 1.250000e+00 : f32} : f32
  %c1 = constant %f#1 {value = 2.500000e+00 : f32} : f32
  %c1f:2 = fork [2] %c1 : f32
  %sum = arith.addf %c0, %c1f#0 : f32
  %gt = arith.cmpf ogt, %sum, %c1f#1 : f32
  return %sum, %gt : f32, i1
}
