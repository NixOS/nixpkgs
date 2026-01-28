{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  python,
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
  importlib-metadata,
  onnx,
  onnxscript,
  pydantic,

  # tests
  nvdlfw-inspect,
  onnxruntime,
  onnxruntime-extensions,
  pytestCheckHook,
  transformers,

  transformer-engine,

  cudaSupport ? config.cudaSupport,
}:

buildPythonPackage (finalAttrs: {
  pname = "transformer-engine";
  version = "2.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TransformerEngine";
    tag = "v${finalAttrs.version}";
    # Their CMakeLists.txt does not easily let us inject dependencies
    fetchSubmodules = true;
    hash = "sha256-O4BTStXmk5ehVff0FfE7NpWP7yRDlDoVNuEx/dPfwRM=";
  };

  patches = lib.optionals cudaSupport [
    (replaceVars ./cuda-libs-paths.patch {
      cudnn = lib.getLib cudaPackages.cudnn;
      cuda_nvrtc = lib.getLib cudaPackages.cuda_nvrtc;
      libcurand = lib.getLib cudaPackages.libcurand;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pybind11[global]" "pybind11" \
      --replace-fail '"pip",' ""
  ''
  + lib.optionalString cudaSupport ''
    substituteInPlace transformer_engine/common/__init__.py \
      --replace-fail \
        'te_path = Path(importlib.util.find_spec("transformer_engine").origin).parent.parent' \
        'te_path = Path("${placeholder "out"}/${python.sitePackages}")'
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
    importlib-metadata
    onnx
    onnxscript
    pydantic
  ];

  pythonImportsCheck = [ "transformer_engine" ];

  nativeCheckInputs = [
    nvdlfw-inspect
    onnxruntime
    onnxruntime-extensions
    pytestCheckHook
    transformers
  ];

  preCheck = ''
    rm -rf transformer_engine
  '';

  enabledTestPaths = [
    # Otherwise pytest recurses into ./third_parties/
    "tests"
  ];

  passthru.gpuCheck = transformer-engine.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    disabledTestPaths = [ ];
  };

  meta = {
    description = "Library for accelerating Transformer models on NVIDIA GPUs";
    homepage = "https://github.com/NVIDIA/TransformerEngine";
    changelog = "https://github.com/NVIDIA/TransformerEngine/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !cudaSupport;
  };
})
