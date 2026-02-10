// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_sin_f32
// CHECK: hw.module.extern @circt_fp_cos_f32
// CHECK: hw.module.extern @circt_fp_tan_f32
// CHECK: hw.module.extern @circt_fp_ceil_f32
// CHECK: hw.module.extern @circt_fp_floor_f32
// CHECK: hw.module.extern @circt_fp_round_f32
// CHECK: hw.module.extern @circt_fp_roundeven_f32
// CHECK: hw.module.extern @circt_fp_trunc_f32
// CHECK: hw.module.extern @circt_fp_log2_f32
// CHECK: hw.module.extern @circt_fp_log10_f32
// CHECK: hw.module.extern @circt_fp_log1p_f32
// CHECK: hw.module.extern @circt_fp_expm1_f32
// CHECK: hw.module.extern @circt_fp_cbrt_f32
// CHECK: hw.instance "u_fp" @circt_fp_sin_f32
// CHECK: hw.instance "u_fp" @circt_fp_cos_f32
// CHECK: hw.instance "u_fp" @circt_fp_tan_f32
// CHECK: hw.instance "u_fp" @circt_fp_ceil_f32
// CHECK: hw.instance "u_fp" @circt_fp_floor_f32
// CHECK: hw.instance "u_fp" @circt_fp_round_f32
// CHECK: hw.instance "u_fp" @circt_fp_roundeven_f32
// CHECK: hw.instance "u_fp" @circt_fp_trunc_f32
// CHECK: hw.instance "u_fp" @circt_fp_log2_f32
// CHECK: hw.instance "u_fp" @circt_fp_log10_f32
// CHECK: hw.instance "u_fp" @circt_fp_log1p_f32
// CHECK: hw.instance "u_fp" @circt_fp_expm1_f32
// CHECK: hw.instance "u_fp" @circt_fp_cbrt_f32
// CHECK-NOT: $itor
// CHECK-NOT: $bitstoshortreal
// CHECK-NOT: $shortrealtobits
// CHECK-NOT: $bitstoreal
// CHECK-NOT: $realtobits
// CHECK-NOT: shortreal
// CHECK-NOT: real

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
