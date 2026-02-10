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
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top test_fp_ext; stat"

handshake.func @test_fp_ext(%ctrl: none, ...) -> (f64, f32, f32, f32, f32, f32, f32, f32) {
  %ctrls:2 = fork [2] %ctrl : none
  %c0 = constant %ctrls#0 {value = 3.250000e+00 : f32} : f32
  %c1 = constant %ctrls#1 {value = 1.500000e+00 : f32} : f32
  %c0f:8 = fork [8] %c0 : f32
  %c1f:2 = fork [2] %c1 : f32

  %ext = arith.extf %c0f#0 : f32 to f64
  %neg = arith.negf %c0f#1 : f32
  %mxn = arith.maxnumf %c0f#2, %c1f#0 : f32
  %mnn = arith.minnumf %c0f#3, %c1f#1 : f32
  %abs = math.absf %neg : f32
  %exp2 = math.exp2 %c0f#4 : f32
  %sq = math.sqrt %c0f#5 : f32
  %lg = math.log %c0f#6 : f32

  return %ext, %neg, %mxn, %mnn, %abs, %exp2, %sq, %lg : f64, f32, f32, f32, f32, f32, f32, f32
}
