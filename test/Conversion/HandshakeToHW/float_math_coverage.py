# REQUIRES: python
# RUN: %PYTHON %s

import pathlib
import re
import sys


def read(path: pathlib.Path) -> str:
    return path.read_text(encoding="utf-8")


def main() -> int:
    root = pathlib.Path(__file__).resolve().parents[3]
    math_td = root / "llvm/mlir/include/mlir/Dialect/Math/IR/MathOps.td"
    hs_cpp = root / "lib/Conversion/HandshakeToHW/HandshakeToHW.cpp"

    td_text = read(math_td)
    hs_text = read(hs_cpp)

    declared = set(
        re.findall(
            r"def (Math_[A-Za-z0-9]+) : Math_(?:FloatUnaryOp|FloatBinaryOp|"
            r"FloatTernaryOp|FloatClassificationOp|Op<\"fpowi\"|Op<\"sincos\")",
            td_text,
        )
    )
    mentioned = set(re.findall(r"math::([A-Za-z0-9]+Op)", hs_text))
    mentioned = {"Math_" + op for op in mentioned}

    missing = sorted(declared - mentioned)
    if missing:
        sys.stderr.write("HandshakeToHW missing float math op coverage:\n")
        for op in missing:
            sys.stderr.write(f"  - {op}\n")
        return 1

    print(f"OK: {len(declared)} float math ops covered by HandshakeToHW")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
