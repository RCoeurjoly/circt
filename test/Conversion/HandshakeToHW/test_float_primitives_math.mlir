// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_addf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_subf_f32
// CHECK: hw.module.extern @circt_fp_mulf_f32
// CHECK: hw.module.extern @circt_fp_divf_f32
// CHECK: hw.module.extern @circt_fp_maxf_f32
// CHECK: hw.module.extern @circt_fp_minf_f32
// CHECK: hw.module.extern @circt_fp_exp_f32
// CHECK: hw.module.extern @circt_fp_rsqrt_f32
// CHECK: hw.module.extern @circt_fp_tanh_f32
// CHECK: hw.module.extern @circt_fp_fpowi_f32_si64
// CHECK: hw.module.extern @circt_fp_truncf_f64_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.instance "u_fp" @circt_fp_addf_f32
// CHECK: hw.instance "u_fp" @circt_fp_subf_f32
// CHECK: hw.instance "u_fp" @circt_fp_mulf_f32
// CHECK: hw.instance "u_fp" @circt_fp_divf_f32
// CHECK: hw.instance "u_fp" @circt_fp_maxf_f32
// CHECK: hw.instance "u_fp" @circt_fp_minf_f32
// CHECK: hw.instance "u_fp" @circt_fp_exp_f32
// CHECK: hw.instance "u_fp" @circt_fp_rsqrt_f32
// CHECK: hw.instance "u_fp" @circt_fp_tanh_f32
// CHECK: hw.instance "u_fp" @circt_fp_fpowi_f32_si64
// CHECK: hw.instance "u_fp" @circt_fp_truncf_f64_f32
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

handshake.func @test_fp_ops(%ctrl: none, ...) -> (f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32) {
  %ctrls:4 = fork [4] %ctrl : none

  %c0 = constant %ctrls#0 {value = 1.250000e+00 : f32} : f32
  %c1 = constant %ctrls#1 {value = 2.500000e+00 : f32} : f32
  %c2 = constant %ctrls#2 {value = 1.000000e+00 : f64} : f64
  %ce = constant %ctrls#3 {value = 3 : i64} : i64

  %c0f:9 = fork [9] %c0 : f32
  %c1f:5 = fork [5] %c1 : f32

  %add = arith.addf %c0f#0, %c1f#0 : f32
  %sub = arith.subf %c0f#1, %c1f#1 : f32
  %mul = arith.mulf %c0f#2, %c1f#2 : f32
  %div = arith.divf %c0f#3, %c1f#3 : f32
  %max = arith.maximumf %c0f#4, %c1 : f32
  %min = arith.minimumf %c0f#5, %c1f#4 : f32
  %exp = math.exp %c0f#6 : f32
  %rsq = math.rsqrt %c0f#7 : f32
  %tanh = math.tanh %c0f#8 : f32
  %pow = math.fpowi %c0, %ce : f32, i64
  %tr = arith.truncf %c2 : f64 to f32

  return %add, %sub, %mul, %div, %max, %min, %exp, %rsq, %tanh, %pow, %tr : f32, f32, f32, f32, f32, f32, f32, f32, f32, f32, f32
}
