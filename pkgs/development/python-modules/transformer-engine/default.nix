{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  cudaPackages,

  # build-system
  cmake,
  flax,
  jax,
  ninja,
  pybind11,
  setuptools,
  torch,

  # dependencies
  einops,
  onnx,
  onnxscript,
  pydantic,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "transformer-engine";
  version = "2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TransformerEngine";
    tag = "v${version}";
    # Their CMakeLists.txt does not easily let us inject dependencies
    fetchSubmodules = true;
    hash = "sha256-O4BTStXmk5ehVff0FfE7NpWP7yRDlDoVNuEx/dPfwRM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11" \
      --replace-fail '"pip",' ""
  '';

  build-system = [
    cmake
    flax
    jax
    ninja
    pybind11
    setuptools
    torch
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart # cuda_runtime.h
    cudaPackages.cuda_nvml_dev # nvml.h
    cudaPackages.cuda_nvrtc # nvrtc.h
    cudaPackages.cuda_nvtx # nvToolsExt.h
    cudaPackages.cuda_profiler_api # cuda_profiler_api.h
    cudaPackages.cudnn
    cudaPackages.libcublas
    cudaPackages.libcurand # curand.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.nccl # nccl.h
    pybind11 # pybind11/pybind11.h
  ];

  env = {
    NVTE_CMAKE_EXTRA_ARGS = toString [
      (lib.cmakeFeature "CUDNN_INCLUDE_DIR" "${lib.getInclude cudaPackages.cudnn}/include")
      (lib.cmakeFeature "CUDNN_FRONTEND_INCLUDE_DIR" "${lib.getInclude cudaPackages.cudnn-frontend}/include")
    ];
  };

  dependencies = [
    einops
    onnx
    onnxscript
    pydantic
  ];

  pythonImportsCheck = [ "transformer_engine" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Library for accelerating Transformer models on NVIDIA GPUs";
    homepage = "https://github.com/NVIDIA/TransformerEngine";
    changelog = "https://github.com/NVIDIA/TransformerEngine/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !config.cudaSupport;
  };
}
