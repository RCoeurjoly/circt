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
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top test_fp_unary; stat"

handshake.func @test_fp_unary(%ctrl: none, ...) -> (f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32) {
  %c = constant %ctrl {value = 2.250000e+00 : f32} : f32
  %f:13 = fork [13] %c : f32
  %sin = math.sin %f#0 : f32
  %cos = math.cos %f#1 : f32
  %tan = math.tan %f#2 : f32
  %ceil = math.ceil %f#3 : f32
  %floor = math.floor %f#4 : f32
  %round = math.round %f#5 : f32
  %roundeven = math.roundeven %f#6 : f32
  %trunc = math.trunc %f#7 : f32
  %log2 = math.log2 %f#8 : f32
  %log10 = math.log10 %f#9 : f32
  %log1p = math.log1p %f#10 : f32
  %expm1 = math.expm1 %f#11 : f32
  %cbrt = math.cbrt %f#12 : f32
  return %sin, %cos, %tan, %ceil, %floor, %round, %roundeven, %trunc, %log2, %log10, %log1p, %expm1, %cbrt : f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
}
