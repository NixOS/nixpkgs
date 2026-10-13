"""Installed CPU/CUDA CSR reduction regressions; no compilation required."""

import itertools
import json

import torch


def csr_reductions(operators=None, devices=("cpu", "cuda")):
    devices = tuple(devices)
    assert devices, "at least one device is required"
    if any(str(device).startswith("cuda") for device in devices):
        assert torch.cuda.is_available()
    torch.set_num_threads(2)
    operators = {
        "sum": lambda x, dim, keepdim, dtype: x.sum(dim=dim, keepdim=keepdim, dtype=dtype),
        "private-sum": torch._sparse_csr_sum,
        "prod": torch._sparse_csr_prod,
        **(operators or {}),
    }
    dimensions = ((0,), (1,), (0, 1), (1, 0), (-2,), (-1,), ())
    index_types = (torch.int32, torch.int64)
    profiles = (
        (torch.int8, [1] * 129, [8] * 3),
        (torch.uint8, [1] * 257, [8] * 3),
        (torch.int16, [2**14] * 3, [64] * 3),
        (torch.int32, [2**30] * 3, [1024] * 4),
        (torch.int64, [2, 3, 5], [2, 3, 5]),
        (torch.bool, [True] * 129, [True, False, True]),
        (torch.float16, [1024, 0.5, -1024], [256, 256, 1 / 256, 1 / 256]),
        (torch.bfloat16, [256, 1, -256], [1 + 1 / 128] * 128),
        (torch.float32, [1.5, -2, 3], [1.5, -2, 3]),
        (torch.float64, [1.5, -2, 3], [1.5, -2, 3]),
        (torch.complex64, [1 + 2j, -2 + 1j, 3 - 1j], [1 + 2j, -2 + 1j, 3 - 1j]),
        (torch.complex128, [1 + 2j, -2 + 1j, 3 - 1j], [1 + 2j, -2 + 1j, 3 - 1j]),
    )
    cases = []

    def output_dtype(dtype, requested):
        return requested or (
            dtype if dtype.is_floating_point or dtype.is_complex else torch.int64
        )

    def check(csr, operation, dim, requested, expected, kind, exact=False):
        case = {
            "kind": kind, "device": str(csr.device), "operation": operation,
            "dtype": str(csr.dtype), "index_dtype": str(csr.crow_indices().dtype),
            "dim": dim, "requested_dtype": str(requested), "shape": list(csr.shape),
            "values_stride": list(csr.values().stride()),
            "values_storage_offset": csr.values().storage_offset(),
        }
        try:
            result = operators[operation](csr, dim, True, dtype=requested)
            case["result_dtype"] = str(result.dtype)
            assert result.values().ndim == 1, tuple(result.values().shape)
            assert result.values().numel() == result.col_indices().numel()
            if kind == "empty":
                assert result.values().numel() == 0
            assert result.crow_indices().dtype == csr.crow_indices().dtype
            assert result.col_indices().dtype == csr.col_indices().dtype
            torch.sparse_csr_tensor(
                result.crow_indices(), result.col_indices(), result.values(),
                size=result.shape, check_invariants=True,
            )
            # Wide floating products can associate differently across CPU/GPU.
            # Preserve exact narrow-overflow, half-accumulation and stride checks.
            rtol = (8 * torch.finfo(expected.dtype).eps if not exact and expected.dtype in
                    (torch.float32, torch.float64, torch.complex64, torch.complex128)
                    else 0)
            torch.testing.assert_close(result.to_dense().cpu(), expected, rtol=rtol, atol=0)
            case["passed"] = True
        except Exception as error:
            case.update(passed=False, error=f"{type(error).__name__}: {error}")
        cases.append(case)

    def check_line(values, operation, dim, index_dtype, requested, kind, exact=False):
        count, device = values.numel(), values.device
        column = (tuple(axis % 2 for axis in dim) or (0, 1)) == (0,)
        csr = torch.sparse_csr_tensor(
            torch.arange(count + 1, dtype=index_dtype, device=device) if column
            else torch.tensor([0, count], dtype=index_dtype, device=device),
            torch.zeros(count, dtype=index_dtype, device=device) if column
            else torch.arange(count, dtype=index_dtype, device=device),
            values, size=(count, 1) if column else (1, count), check_invariants=True,
        )
        assert csr.values().stride() == values.stride()
        dtype = output_dtype(values.dtype, requested)
        accumulator = torch.float32 if dtype in (torch.float16, torch.bfloat16) else dtype
        reference = values.cpu().to(dtype).to(accumulator)
        # Product reduces stored entries, as used by torch.masked.prod. A dense
        # product is a valid reference here because these lines have no holes.
        reduction = "prod" if operation == "prod" else "sum"
        expected = getattr(reference, reduction)().to(dtype).reshape(1, 1)
        check(csr, operation, dim, requested, expected, kind, exact)

    for dtype, sum_values, prod_values in profiles:
        wide = (
            torch.complex128 if dtype == torch.complex64 else
            torch.complex64 if dtype == torch.complex128 else
            torch.float32 if dtype == torch.float64 else
            torch.float64 if dtype.is_floating_point else torch.int64
        )
        for operation, values in (("sum", sum_values), ("prod", prod_values)):
            for dim, requested, index_dtype, device in itertools.product(
                dimensions, dict.fromkeys((None, dtype, wide)), index_types, devices
            ):
                check_line(
                    torch.tensor(values, dtype=dtype, device=device), operation,
                    dim, index_dtype, requested, "promotion",
                    exact=dtype in (torch.int8, torch.int32, torch.bool, torch.float16),
                )

        # Retain the upstream dtype cases, including all-true boolean products,
        # complex-to-real outputs and both negative axes in one reduction.
        for operation in ("private-sum", "prod"):
            values = [1] * 257 if operation == "private-sum" else [8] * 3
            if dtype == torch.int32:
                values = [2**30] * 3 if operation == "private-sum" else [1024] * 4
            elif dtype == torch.float16 and operation == "prod":
                values = [256, 256, 1 / 256, 1 / 256]
            for dim, requested, index_dtype, device in itertools.product(
                ((0,), (1,), (0, 1), (1, 0), (-1, -2), ()),
                dict.fromkeys((None, dtype, torch.float64)), index_types, devices,
            ):
                check_line(torch.tensor(values, dtype=dtype, device=device), operation,
                           dim, index_dtype, requested, "promotion", exact=True)

    # Private sum dispatch and explicit floating output of integer products.
    for dtype, values, operation in (
        (torch.int8, [64, 64, 1], "private-sum"),
        (torch.int32, [2**30] * 3, "private-sum"),
        (torch.bool, [True, False, True], "private-sum"),
        (torch.int8, [8] * 3, "prod"),
        (torch.int32, [1024] * 4, "prod"),
        (torch.bool, [True, False, True], "prod"),
    ):
        requests = (None, dtype, torch.float64) if operation == "private-sum" else (torch.float64,)
        for dim, requested, index_dtype, device in itertools.product(
            dimensions[:3], requests, index_types, devices
        ):
            check_line(torch.tensor(values, dtype=dtype, device=device), operation,
                       dim, index_dtype, requested, "promotion", exact=True)

    # Empty stored groups remain absent, including zero-sized axes.
    for dtype in (torch.int8, torch.float32):
        for shape, dim, requested, index_dtype, device in itertools.product(
            ((0, 0), (0, 3), (3, 0), (3, 4)), dimensions[:3],
            (None, dtype), index_types, devices,
        ):
            csr = torch.sparse_csr_tensor(
                torch.zeros(shape[0] + 1, dtype=index_dtype, device=device),
                torch.empty(0, dtype=index_dtype, device=device),
                torch.empty(0, dtype=dtype, device=device), size=shape, check_invariants=True,
            )
            result_shape = tuple(1 if axis in dim else size for axis, size in enumerate(shape))
            expected = torch.zeros(result_shape, dtype=output_dtype(dtype, requested))
            selected = ("sum", "prod")
            if dtype == torch.int8 and shape != (0, 0):
                selected += ("private-sum",)
            for operation in selected:
                check(csr, operation, dim, requested, expected, "empty", exact=True)

    # Poison skipped storage; cover both zero-stride offsets and non-unit stride.
    for dtype, _, _ in profiles:
        layouts = ((0, 0), (2, 1)) + (((0, 1),) if dtype in (torch.int8, torch.float32) else ())
        for (stride, offset), index_dtype, device in itertools.product(layouts, index_types, devices):
            data = ([False, True, True, True, True, False, False]
                    if dtype == torch.bool else [99, 2, 99, 3, 99, 5, 99])
            if offset == 0:
                data = [False, True, True] if dtype == torch.bool else [2, 99, 99]
            storage = torch.tensor(data, dtype=dtype, device=device)
            before = storage.clone()
            values = storage[offset::2] if stride == 2 else storage[offset:offset + 1].expand(3)
            selected = ("sum", "prod") if stride == 2 or offset == 0 else ("prod",)
            if dtype in (torch.int8, torch.float32) and offset == 1:
                selected += ("private-sum",)
            for operation, dim, requested in itertools.product(selected, dimensions[:3], (None, dtype)):
                check_line(values, operation, dim, index_dtype, requested, "strided-values", exact=True)
            torch.testing.assert_close(storage, before, rtol=0, atol=0)

    # Holes and an empty row/column retain stored-entry product semantics.
    for index_dtype, device in itertools.product(index_types, devices):
        csr = torch.sparse_csr_tensor(
            torch.tensor([0, 2, 2, 3], dtype=index_dtype, device=device),
            torch.tensor([0, 2, 0], dtype=index_dtype, device=device),
            torch.tensor([2, 3, 5], dtype=torch.int8, device=device),
            size=(3, 4), check_invariants=True,
        )
        for operation in ("sum", "prod"):
            references = ([[10, 0, 3, 0]], [[6], [0], [5]], [[30]]) if operation == "prod" else (
                [[7, 0, 3, 0]], [[5], [0], [5]], [[10]]
            )
            for dim, expected in zip(dimensions[:3], references):
                check(csr, operation, dim, None, torch.tensor(expected), "masked-structure", exact=True)
    return {"passed": all(case["passed"] for case in cases), "count": len(cases),
            "failures": sum(not case["passed"] for case in cases), "cases": cases}


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--device", action="append", choices=("cpu", "cuda"))
    args = parser.parse_args()
    result = csr_reductions(devices=args.device or ("cpu", "cuda"))
    print(json.dumps({"torch": torch.__version__, "torch_path": torch.__file__, **result,
                      "cases": [case for case in result["cases"] if not case["passed"]]}, indent=2))
    raise SystemExit(0 if result["passed"] else 1)
