// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_asin_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_acos_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_atan_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_asinh_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_acosh_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_atanh_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_sinh_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_cosh_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_erf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_erfc_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.instance "u_fp" @circt_fp_asin_f32
// CHECK: hw.instance "u_fp" @circt_fp_acos_f32
// CHECK: hw.instance "u_fp" @circt_fp_atan_f32
// CHECK: hw.instance "u_fp" @circt_fp_asinh_f32
// CHECK: hw.instance "u_fp" @circt_fp_acosh_f32
// CHECK: hw.instance "u_fp" @circt_fp_atanh_f32
// CHECK: hw.instance "u_fp" @circt_fp_sinh_f32
// CHECK: hw.instance "u_fp" @circt_fp_cosh_f32
// CHECK: hw.instance "u_fp" @circt_fp_erf_f32
// CHECK: hw.instance "u_fp" @circt_fp_erfc_f32
// CHECK-NOT: $itor
// CHECK-NOT: $bitstoshortreal
// CHECK-NOT: $shortrealtobits
// CHECK-NOT: $bitstoreal
// CHECK-NOT: $realtobits
// CHECK-NOT: shortreal
// CHECK-NOT: real

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
