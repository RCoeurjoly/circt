// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_atan2_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_powf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_fma_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_copysign_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_isfinite_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_isnan_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.instance "u_fp" @circt_fp_atan2_f32
// CHECK: hw.instance "u_fp" @circt_fp_powf_f32
// CHECK: hw.instance "u_fp" @circt_fp_fma_f32
// CHECK: hw.instance "u_fp" @circt_fp_copysign_f32
// CHECK: hw.instance "u_fp" @circt_fp_isfinite_f32
// CHECK: hw.instance "u_fp" @circt_fp_isnan_f32
// CHECK-NOT: $itor
// CHECK-NOT: $bitstoshortreal
// CHECK-NOT: $shortrealtobits
// CHECK-NOT: $bitstoreal
// CHECK-NOT: $realtobits
// CHECK-NOT: shortreal
// CHECK-NOT: real

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
