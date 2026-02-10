// RUN: circt-opt -lower-handshake-to-hw %s | FileCheck %s

// CHECK-LABEL: hw.module @arith_divui
// CHECK: comb.divu
// CHECK-LABEL: hw.module @arith_divsi
// CHECK: comb.divs
// CHECK-LABEL: hw.module @arith_remui
// CHECK: comb.modu
// CHECK-LABEL: hw.module @arith_remsi
// CHECK: comb.mods

handshake.func @test_div_rem(%ctrl: none, ...) -> (i32, i32, i32, i32) {
  %f:2 = fork [2] %ctrl : none
  %a = constant %f#0 {value = 7 : i32} : i32
  %b = constant %f#1 {value = 3 : i32} : i32
  %af:4 = fork [4] %a : i32
  %bf:4 = fork [4] %b : i32
  %du = arith.divui %af#0, %bf#0 : i32
  %ds = arith.divsi %af#1, %bf#1 : i32
  %ru = arith.remui %af#2, %bf#2 : i32
  %rs = arith.remsi %af#3, %bf#3 : i32
  return %du, %ds, %ru, %rs : i32, i32, i32, i32
}
