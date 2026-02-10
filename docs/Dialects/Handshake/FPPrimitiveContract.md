# Handshake FP Primitive Contract

`-lower-handshake-to-hw` lowers Handshake floating-point operations to external
modules named `circt_fp_*`. These are emitted as `hw.module.extern` and marked
with `sv.attributes = [#sv.attribute<"blackbox">]`.

This document defines the contract expected by downstream RTL libraries that
implement these extern modules.

## Why this exists

- SystemVerilog `real`/`shortreal` system functions are not synthesizable in
  Yosys flows.
- Handshake lowering therefore emits blackbox primitive instances instead of
  `$itor`, `$pow`, `$exp`, and similar constructs.

## Naming and signatures

Primitive names encode operation and operand/result widths.

- Unary conversion:
  - `circt_fp_truncf_f<SRC>_f<DST>`: `f<SRC> -> f<DST>`
  - `circt_fp_extf_f<SRC>_f<DST>`: `f<SRC> -> f<DST>`
  - `circt_fp_uitofp_ui<W>_f<F>`: `i<W> -> f<F>`
  - `circt_fp_sitofp_si<W>_f<F>`: `i<W> -> f<F>`
- Unary arithmetic/math:
  - `circt_fp_negf_f<F>`
  - `circt_fp_absf_f<F>`
  - `circt_fp_exp_f<F>`
  - `circt_fp_exp2_f<F>`
  - `circt_fp_log_f<F>`
  - `circt_fp_sqrt_f<F>`
  - `circt_fp_rsqrt_f<F>`
  - `circt_fp_tanh_f<F>`
- Binary arithmetic:
  - `circt_fp_addf_f<F>`
  - `circt_fp_subf_f<F>`
  - `circt_fp_mulf_f<F>`
  - `circt_fp_divf_f<F>`
  - `circt_fp_maxf_f<F>`
  - `circt_fp_minf_f<F>`
  - `circt_fp_maxnumf_f<F>`
  - `circt_fp_minnumf_f<F>`
- Comparisons:
  - `circt_fp_cmpf_<pred>_f<F>`: returns `i1`
- Mixed:
  - `circt_fp_fpowi_f<F>_si<W>`: `(f<F>, i<W>) -> f<F>` (signed exponent semantics)

Port convention:

- Inputs: `in0`, `in1`, ... in operand order.
- Output: single `out0`.

## Semantic expectations

To preserve functional equivalence with source programs (for example PyTorch
models), implementations should follow IEEE-754 behavior for the represented
format, including:

- NaN propagation behavior matching the originating operation semantics.
- Signed zero handling.
- Infinity behavior.
- Rounding mode consistency (default round-to-nearest ties-to-even unless your
  frontend defines otherwise).

For `maxnumf`/`minnumf`, implement num-semantics distinct from
`maximumf`/`minimumf` when NaNs are present.

## Latency and handshake expectations

The generated modules are pure value-level combinational blackboxes at the IR
boundary: no explicit valid/ready ports are part of these primitive module
interfaces. If a backend maps these to pipelined IP, it must preserve dataflow
ordering/latency correctness at the enclosing hardware level.

## Verification checklist

For each target backend library:

1. Parse/elaborate emitted SV with your synthesis frontend (Yosys/Slang/etc.).
2. Confirm no `real`, `shortreal`, or float system functions remain in emitted
   synthesizable SV.
3. Confirm all emitted `circt_fp_*` symbols resolve to provided modules.
4. Run model-vs-RTL numerical conformance tests over representative workloads
   and corner-case floating-point vectors.
