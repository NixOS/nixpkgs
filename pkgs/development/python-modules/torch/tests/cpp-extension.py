import os
from pathlib import Path
import tempfile

# Exercise the installed consumer interface, without stdenv's search flags.
for name in list(os.environ):
    if name.startswith("NIX_") or name in {
        "CFLAGS", "CXXFLAGS", "CPPFLAGS", "LDFLAGS", "CPATH", "C_INCLUDE_PATH",
        "CPLUS_INCLUDE_PATH", "LIBRARY_PATH", "CUDA_INC_PATH", "CUDNN_HOME",
        "NVCC_PREPEND_FLAGS", "NVCC_APPEND_FLAGS",
    }:
        del os.environ[name]

import torch
from torch.utils.cpp_extension import load

with tempfile.TemporaryDirectory(prefix="torch-cpp-extension-") as directory:
    root = Path(directory)
    (root / "binding.cpp").write_text(r"""
#include <pybind11/pybind11.h>
#include <ATen/cuda/CUDAContext.h>
#include <cstdint>
extern "C" int saxpy_launch(float*, const float*, int);
PYBIND11_MODULE(TORCH_EXTENSION_NAME, module) {
  module.def("run", [](std::uintptr_t y, std::uintptr_t x, int n) {
    return saxpy_launch(reinterpret_cast<float*>(y), reinterpret_cast<const float*>(x), n);
  });
}
""")
    (root / "saxpy.cu").write_text(r"""
#include <cuda_runtime.h>
__global__ void saxpy(float* y, const float* x, int n) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) y[i] = 2.0f * x[i] + y[i];
}
extern "C" int saxpy_launch(float* y, const float* x, int n) {
  saxpy<<<(n + 255) / 256, 256>>>(y, x, n);
  return static_cast<int>(cudaGetLastError());
}
""")
    module = load(
        name="torch_cpp_extension_saxpy",
        sources=[str(root / "binding.cpp"), str(root / "saxpy.cu")],
        build_directory=str(root),
        verbose=True,
    )
    x = torch.arange(1024, device="cuda", dtype=torch.float32)
    y = torch.full_like(x, 3.0)
    assert module.run(y.data_ptr(), x.data_ptr(), x.numel()) == 0
    torch.cuda.synchronize()
    torch.testing.assert_close(y, 2 * x + 3, atol=0, rtol=0)
    print(f"Ordinary C++/CUDA extension passed on {torch.cuda.get_device_name()}")
