// RUN: circt-opt -handshake-materialize-forks-sinks -lower-handshake-to-hw %s | FileCheck %s

// CHECK: hw.module.extern @circt_fp_sincos_f32{{.*}}sv.attributes = [#sv.attribute<"blackbox">]
// CHECK: hw.instance "u_fp" @circt_fp_sincos_f32
// CHECK-NOT: $itor
// CHECK-NOT: $bitstoshortreal
// CHECK-NOT: $shortrealtobits
// CHECK-NOT: $bitstoreal
// CHECK-NOT: $realtobits
// CHECK-NOT: shortreal
// CHECK-NOT: real

handshake.func @test_fp_sincos(%ctrl: none, ...) -> (f32, f32) {
  %c = constant %ctrl {value = 2.250000e+00 : f32} : f32
  %s, %co = math.sincos %c : f32
  return %s, %co : f32, f32
}
