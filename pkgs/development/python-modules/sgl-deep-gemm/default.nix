{
  lib,
  buildPythonPackage,
  cudaPackages,
  fetchFromGitHub,

  apache-tvm-ffi,
  pybind11,
  pytestCheckHook,
  setuptools,
  torch,
}:
buildPythonPackage (finalAttrs: {
  pname = "sgl-deep-gemm";
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sgl-project";
    repo = "DeepGEMM";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OK6/0j7NmXbdr9RlSpsFlEZqVqYcQgmsmJzYJOvvLb0=";
  };

  # build_sgl_deep_gemm.sh
  postPatch = ''
    mkdir build

    cp -r deep_gemm build/
    cp -r sgl_deep_gemm/{LICENSE,README.md,pyproject.toml} build/
    cp -r sgl_deep_gemm/__init__.py build/deep_gemm/

    echo "${finalAttrs.version}" >build/deep_gemm/VERSION

    awk "/PY/{p=0}p;/<<'PY'/{p=1}" build_sgl_deep_gemm.sh >build.py
  '';

  preBuild = ''
    ROOT_DIR="$PWD" PKG_DIR="$PWD/build/deep_gemm" python3 -u build.py

    cd build
  '';

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart # cuda.h
    cudaPackages.cuda_nvrtc # nvrtc.h
    cudaPackages.cutlass # cute/arch/mma_sm100_desc.hpp
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcusparse # cusparse.h
    pybind11 # pybind11/pybind11.h
  ];

  build-system = [
    apache-tvm-ffi
    setuptools
    torch
  ];

  dependencies = [
    apache-tvm-ffi
  ];

  pythonRelaxDeps = [
    "apache-tvm-ffi"
  ];

  pythonImportsCheck = [
    "deep_gemm"
  ];

  # pythonImportsCheckPhase
  env.CUDA_HOME = "${cudaPackages.cuda_nvcc}";

  meta = {
    description = "Unified, high-performance tensor core kernel library";
    homepage = "https://github.com/sgl-project/DeepGEMM";
    downloadPage = "https://github.com/sgl-project/DeepGEMM/tags";
    license = with lib.licenses; [
      asl20 # sgl_deep_gemm/LICENSE
      mit # ICENSE
    ];
    maintainers = with lib.maintainers; [ prince213 ];
  };
})
