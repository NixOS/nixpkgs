"""Check the installed Torch BLAS selection, including strided/conjugate inputs.

Run directly with the Python environment under review, outside setup hooks.
"""

import json
import torch


def cpu_dot():
    cases = 0
    for dtype in (torch.float32, torch.float64, torch.complex64, torch.complex128):
        values = torch.arange(1, 18, dtype=torch.float64).to(dtype)
        if dtype.is_complex:
            values = values + 0.25j * values.flip(0)
        for lhs, rhs in (
            (values, values),
            (values[::2], values.flip(0)[::2]),
            (values.conj(), values),
        ):
            torch.testing.assert_close(torch.dot(lhs, rhs), (lhs * rhs).sum())
            torch.testing.assert_close(torch.vdot(lhs, rhs), (lhs.conj() * rhs).sum())
            cases += 2
    return {"passed": True, "cases": cases}


if __name__ == "__main__":
    torch.set_num_threads(2)
    print(json.dumps({"torch": torch.__version__, "torch_path": torch.__file__,
                      "cuda": torch.version.cuda, **cpu_dot()}, indent=2))
