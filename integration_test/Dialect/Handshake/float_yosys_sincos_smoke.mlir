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
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top test_fp_sincos; stat"

handshake.func @test_fp_sincos(%ctrl: none, ...) -> (f32, f32) {
  %c = constant %ctrl {value = 2.250000e+00 : f32} : f32
  %s, %co = math.sincos %c : f32
  return %s, %co : f32, f32
}
