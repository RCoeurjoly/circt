// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_addf_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module.extern @circt_fp_cmpf_ogt_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.module @arith_addf_in_f32_f32_out_f32
// CHECK: hw.instance "u_fp" @circt_fp_addf_f32
// CHECK: hw.module @arith_cmpf_in_f32_f32_out_ui1
// CHECK: hw.instance "u_fp" @circt_fp_cmpf_ogt_f32
// CHECK-NOT: $itor
// CHECK-NOT: $bitstoshortreal
// CHECK-NOT: $shortrealtobits
// CHECK-NOT: $bitstoreal
// CHECK-NOT: $realtobits
// CHECK-NOT: shortreal
// CHECK-NOT: real

handshake.func @test_fp(%ctrl: none, ...) -> (f32, i1) {
  %f:2 = fork [2] %ctrl : none
  %c0 = constant %f#0 {value = 1.250000e+00 : f32} : f32
  %c1 = constant %f#1 {value = 2.500000e+00 : f32} : f32
  %c1f:2 = fork [2] %c1 : f32
  %sum = arith.addf %c0, %c1f#0 : f32
  %gt = arith.cmpf ogt, %sum, %c1f#1 : f32
  return %sum, %gt : f32, i1
}
