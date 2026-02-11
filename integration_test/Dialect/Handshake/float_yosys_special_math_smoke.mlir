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
// RUN: yosys -p "read_verilog -sv %t.sv; hierarchy -top test_fp_special; stat"

handshake.func @test_fp_special(%ctrl: none, ...) -> (f32, f32, f32, f32, f32, f32, f32, f32, f32, f32) {
  %c = constant %ctrl {value = 4.000000e-01 : f32} : f32
  %f:10 = fork [10] %c : f32
  %asin = math.asin %f#0 : f32
  %acos = math.acos %f#1 : f32
  %atan = math.atan %f#2 : f32
  %asinh = math.asinh %f#3 : f32
  %acosh = math.acosh %f#4 : f32
  %atanh = math.atanh %f#5 : f32
  %sinh = math.sinh %f#6 : f32
  %cosh = math.cosh %f#7 : f32
  %erf = math.erf %f#8 : f32
  %erfc = math.erfc %f#9 : f32
  return %asin, %acos, %atan, %asinh, %acosh, %atanh, %sinh, %cosh, %erf, %erfc : f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
}
