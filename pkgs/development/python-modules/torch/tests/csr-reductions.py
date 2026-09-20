"""Installed CPU/CUDA CSR reduction regressions; no compilation required."""

import itertools

import torch


def main():
    torch.set_num_threads(2)
    assert torch.cuda.is_available()
    operations = {"sum": torch._sparse_csr_sum, "prod": torch._sparse_csr_prod}
    dimensions = ((0,), (1,), (0, 1))
    index_types = (torch.int32, torch.int64)
    cases = 0

    def check(csr, operation, dim, requested, expected):
        nonlocal cases
        result = operations[operation](csr, dim, True, dtype=requested)
        assert result.values().ndim == 1
        assert result.values().numel() == result.col_indices().numel()
        assert result.crow_indices().dtype == csr.crow_indices().dtype
        assert result.col_indices().dtype == csr.col_indices().dtype
        torch.sparse_csr_tensor(
            result.crow_indices(), result.col_indices(), result.values(),
            size=result.shape, check_invariants=True,
        )
        torch.testing.assert_close(
            result.to_dense().cpu(), expected, check_dtype=False, rtol=0, atol=0
        )
        assert result.dtype == expected.dtype, (result.dtype, expected.dtype)
        cases += 1

    def check_line(values, dim, index_type, requested, selected_operations=("sum", "prod")):
        count, device = values.numel(), values.device
        column = dim == (0,)
        csr = torch.sparse_csr_tensor(
            torch.arange(count + 1, dtype=index_type, device=device) if column
            else torch.tensor([0, count], dtype=index_type, device=device),
            torch.zeros(count, dtype=index_type, device=device) if column
            else torch.arange(count, dtype=index_type, device=device),
            values, size=(count, 1) if column else (1, count), check_invariants=True,
        )
        dtype = requested or (
            values.dtype if values.is_floating_point() else torch.int64
        )
        accumulator = torch.float32 if dtype == torch.float16 else dtype
        reference = values.cpu().to(dtype).to(accumulator)
        for operation in selected_operations:
            expected = getattr(reference, operation)().to(dtype).reshape(1, 1)
            check(csr, operation, dim, requested, expected)

    # Inputs expose narrow overflow and half-product intermediate overflow.
    for dtype, data, selected_operations in (
        (torch.int8, [64, 64, 1], ("sum",)),
        (torch.int8, [8, 8, 8], ("prod",)),
        (torch.int32, [2**30, 2**30, 2**30], ("sum",)),
        (torch.int32, [1024, 1024, 1024, 1024], ("prod",)),
        (torch.float16, [256, 256, 1 / 256, 1 / 256], ("prod",)),
        (torch.bool, [True, False, True], ("sum", "prod")),
    ):
        for device, dim, index_type, requested in itertools.product(
            ("cpu", "cuda"), dimensions, index_types, (None, dtype, torch.float64)
        ):
            check_line(
                torch.tensor(data, dtype=dtype, device=device), dim, index_type,
                requested, selected_operations,
            )

    # Skipped storage is poisoned; reduction must respect both offset and stride.
    for device, dtype, stride in itertools.product(
        ("cpu", "cuda"), (torch.int8, torch.float32), (0, 2)
    ):
        storage = torch.tensor([99, 2, 99, 3, 99, 5, 99], dtype=dtype, device=device)
        before = storage.clone()
        values = storage[1::2] if stride == 2 else storage[1:2].expand(3)
        for dim, index_type, requested in itertools.product(dimensions, index_types, (None, dtype)):
            check_line(values, dim, index_type, requested)
        torch.testing.assert_close(storage, before, rtol=0, atol=0)

    # Empty stored groups stay absent for masked product, including zero-sized axes.
    for device, shape, dim, index_type, requested in itertools.product(
        ("cpu", "cuda"), ((0, 3), (3, 0), (3, 4)), dimensions, index_types, (None, torch.int8)
    ):
        csr = torch.sparse_csr_tensor(
            torch.zeros(shape[0] + 1, dtype=index_type, device=device),
            torch.empty(0, dtype=index_type, device=device),
            torch.empty(0, dtype=torch.int8, device=device), size=shape, check_invariants=True,
        )
        result_shape = tuple(1 if axis in dim else size for axis, size in enumerate(shape))
        expected = torch.zeros(result_shape, dtype=requested or torch.int64)
        for operation in operations:
            check(csr, operation, dim, requested, expected)
    print(f"CSR reduction regressions passed: {cases} cases, {torch.__version__}, {torch.__file__}")


if __name__ == "__main__":
    main()
