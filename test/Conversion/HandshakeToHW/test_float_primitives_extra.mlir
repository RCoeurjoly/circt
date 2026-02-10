// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_extf_f32_f64{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_negf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_maxnumf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_minnumf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_absf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_exp2_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_sqrt_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_log_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.instance "u_fp" @circt_fp_extf_f32_f64
// CHECK: hw.instance "u_fp" @circt_fp_negf_f32
// CHECK: hw.instance "u_fp" @circt_fp_maxnumf_f32
// CHECK: hw.instance "u_fp" @circt_fp_minnumf_f32
// CHECK: hw.instance "u_fp" @circt_fp_absf_f32
// CHECK: hw.instance "u_fp" @circt_fp_exp2_f32
// CHECK: hw.instance "u_fp" @circt_fp_sqrt_f32
// CHECK: hw.instance "u_fp" @circt_fp_log_f32
// CHECK-NOT: $itor
// CHECK-NOT: $bitstoshortreal
// CHECK-NOT: $shortrealtobits
// CHECK-NOT: $bitstoreal
// CHECK-NOT: $realtobits
// CHECK-NOT: $exp
// CHECK-NOT: $sqrt
// CHECK-NOT: $pow
// CHECK-NOT: shortreal
// CHECK-NOT: real

handshake.func @test_fp_extra(%ctrl: none, ...) -> (f64, f32, f32, f32, f32, f32, f32, f32) {
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
