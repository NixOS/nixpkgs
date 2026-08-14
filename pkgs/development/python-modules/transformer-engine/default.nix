{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  python,
  cudaPackages,

  # nativeBuildInputs
  autoAddDriverRunpath,
  autoPatchelfHook,
  mpi,

  # build-system
  cmake,
  ninja,
  pybind11,
  setuptools,
  # jax-only
  flax,
  jax,
  # pytorch-only:
  torch,

  # dependencies
  importlib-metadata,
  packaging,
  pydantic,
  # pytorch-only:
  einops,
  nvdlfw-inspect,
  onnx,
  onnxscript,

  # passthru
  transformer-engine,

  cudaSupport ? config.cudaSupport,
  cudaCapabilities ?
    if withPytorch then torch.cudaCapabilities else cudaPackages.flags.cudaCapabilities,
  withMpi ? false,
  withPytorch ? true,
  withJax ? true,
  withNvshmem ? false,
  withCusolvermp ? false,
  withNcclEp ? true,
}:

let
  inherit (lib)
    cmakeFeature
    concatStringsSep
    getBin
    getInclude
    getLib
    optional
    optionalString
    optionals
    strings
    subtractLists
    ;
  inherit (cudaPackages) backendStdenv flags;

  frameworks =
    if (withJax || withPytorch) then
      concatStringsSep "," (optional withJax "jax" ++ optional withPytorch "pytorch")
    else
      "none";

  cudaCapabilities' = subtractLists [
    # Compilation will fail when providing those architectures:
    #   error: static assertion failed with "Compiled for the generic architecture, while utilizing
    #   family-specific features.
    #   Please compile for smXXXf architecture instead of smXXX architecture."
    # Providing 10.0 and 12.0 respectively is enough as the CMake file will automatically add the
    # correct compilation flags for supporting those architectures.
    "10.3"
    "12.1"
  ] cudaCapabilities;

in
buildPythonPackage.override { stdenv = backendStdenv; } (finalAttrs: {
  pname = "transformer-engine";
  version = "2.17.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TransformerEngine";
    tag = "v${finalAttrs.version}";
    # Their CMakeLists.txt does not easily let us inject dependencies
    fetchSubmodules = true;
    hash = "sha256-W9aWSmYCV7wYrLSAlYE2prfPfucXkPjWGA7NAMfBJ9E=";
  };

  patches = optionals cudaSupport [
    (replaceVars ./cuda-libs-paths.patch {
      libcudnn_so = "${getLib cudaPackages.cudnn}/lib/libcudnn.so";
      libnvrtc_so = "${getLib cudaPackages.cuda_nvrtc}/lib/libnvrtc.so";
      libcurand_so = "${getLib cudaPackages.libcurand}/lib/libcurand.so";

      cudart_include_dir = "${getInclude cudaPackages.cuda_cudart}/include";
    })
  ];

  postPatch =
    # Patch build-system requirements:
    # - pybind11[global] doesn't exist in nixpkgs, just use regular pybind11
    # - pip is not required for building this package
    # - torch, jax and flax should not been unconditionally required, but depending on the selected
    #   'frameworks'
    ''
      substituteInPlace pyproject.toml \
        --replace-fail "pybind11[global]" "pybind11" \
        --replace-fail '"pip", "torch>=2.1", "jax>=0.5.0", "flax>=0.7.1"' ""
    ''
    # Hardcode the path to the output store path that transformer_engine will use to import
    # - libtransformer_engine.so
    # - transformer_engine_jax.cpython-313-x86_64-linux-gnu.so
    # - transformer_engine_torch.cpython-313-x86_64-linux-gnu.so
    # This skips their impure find logic.
    + ''
      substituteInPlace transformer_engine/common/__init__.py \
        --replace-fail \
          'te_path = Path(importlib.util.find_spec("transformer_engine").origin).parent.parent' \
          'te_path = Path("${placeholder "out"}/${python.sitePackages}")'
    ''
    # nccl-ep is built from the vendored `3rdparty/nccl` submodule (see the NCCL_EP_* CMake
    # variables in `transformer_engine/common/CMakeLists.txt`), which pins a newer NCCL than
    # `cudaPackages.nccl-ep` provides.
    # Only `libnccl_ep.a` is consumed (whole-archive), so skip the shared library, which would
    # otherwise need `-lnccl -lcuda` on the link line.
    + optionalString withNcclEp ''
      substituteInPlace 3rdparty/nccl/contrib/nccl_ep/Makefile \
        --replace-fail \
          'lib: $(LIBTARGET) $(SOLIBTARGET) $(SOLIBLINKS) $(HEADER_TARGETS)' \
          'lib: $(LIBTARGET) $(HEADER_TARGETS)'
    '';

  # https://github.com/NVIDIA/TransformerEngine/blob/main/docs/envvars.rst
  env = {
    NVTE_RELEASE_BUILD = 0;

    # Do not include the git commit hash in the version string
    NVTE_NO_LOCAL_VERSION = 1;

    # Use the nixpkgs triton package
    NVTE_USE_PYTORCH_TRITON = 0;

    NVTE_FRAMEWORK = frameworks;

    NVTE_CUDA_ARCHS = strings.concatMapStringsSep ";" flags.dropDots cudaCapabilities';

    NVTE_CMAKE_EXTRA_ARGS = toString [
      (cmakeFeature "CUDNN_FRONTEND_INCLUDE_DIR" "${getInclude cudaPackages.cudnn-frontend}/include")
    ];

    NVTE_WITH_NCCL_EP = if withNcclEp then 1 else 0;
    # Consumed by `3rdparty/nccl/makefiles/common.mk`, which otherwise defaults to
    # `CUDA_HOME = /usr/local/cuda`. Only the nccl-ep headers are needed, so `NCCL_HOME`
    # can point at the `include` output alone.
    NCCL_HOME = optionalString withNcclEp (getInclude cudaPackages.nccl).outPath;
    CUDA_HOME = optionalString withNcclEp (getBin cudaPackages.cuda_nvcc).outPath;
    CUDA_INC = optionalString withNcclEp "${getInclude cudaPackages.cuda_cudart}/include";
    CUDA_LIB = optionalString withNcclEp "${getLib cudaPackages.cuda_cudart}/lib";

    NVTE_UB_WITH_MPI = if withMpi then 1 else 0;
    # NOTE: Make sure to use mpi from buildPackages to match the spliced version created through nativeBuildInputs.
    MPI_HOME = optionalString withMpi (getLib mpi).outPath;

    NVTE_ENABLE_NVSHMEM = if withNvshmem then 1 else 0;
    NVSHMEM_HOME = optionalString withNvshmem cudaPackages.libnvshmem.outPath;

    NVTE_WITH_CUSOLVERMP = if withCusolvermp then 1 else 0;
    CUSOLVERMP_HOME = optionalString withCusolvermp (getLib cudaPackages.libcusolvermp).outPath;
  };

  build-system = [
    cmake
    ninja
    pybind11
    setuptools
  ]
  ++ optionals withJax [
    flax
    jax
  ]
  ++ optionals withPytorch [
    # Required to build extensions
    torch
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
    cudaPackages.cuda_nvcc
  ]
  ++ optionals withMpi [
    # NOTE: mpi is in nativeBuildInputs because it contains compilers and is only discoverable by
    # CMake when a nativeBuildInput.
    mpi
  ];

  buildInputs = [
    cudaPackages.cuda_cudart # cuda_runtime.h
    cudaPackages.cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
    cudaPackages.cuda_nvml_dev # nvml.h
    cudaPackages.cuda_nvrtc # nvrtc.h
    cudaPackages.cuda_nvtx # nvToolsExt.h
    cudaPackages.cuda_profiler_api # cuda_profiler_api.h
    cudaPackages.cudnn # cudnn.h
    cudaPackages.libcublas
    cudaPackages.libcurand # curand.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.nccl # nccl.h
    pybind11 # pybind11/pybind11.h
  ]
  ++ optionals withMpi [
    mpi # mpi.h
  ]
  ++ optionals withCusolvermp [
    cudaPackages.libcusolvermp
  ];

  runtimeDependencies = optionals withNvshmem [
    # libnvshmem is already provided at build time by `$NVSHMEM_HOME`
    # We add it here so that it gets picked up by autoPatchelfHook
    (getLib cudaPackages.libnvshmem)
  ];

  preBuild = ''
    export NVTE_BUILD_MAX_JOBS=$NIX_BUILD_CORES
  '';

  dependencies = [
    importlib-metadata
    packaging
    pydantic
  ]
  ++ optionals withJax [
    flax
    jax
  ]
  ++ optionals withPytorch [
    einops
    nvdlfw-inspect
    onnx
    onnxscript
    torch
  ];

  dontUsePythonImportsCheck =
    # When built with cusolvermp support `dlopen`ing libtransformer_engine.so `dlopen`s
    # libcuda.so.1 which is provided by the GPU driver at run time:
    # OSError: libcuda.so.1: cannot open shared object file: No such file or directory
    withCusolvermp

    # When built with nvshmem support `dlopen`ing libtransformer_engine.so `dlopen`s
    # libnvidia-ml.so.1 which is provided by the GPU driver at run time:
    # OSError: libnvidia-ml.so.1: cannot open shared object file: No such file or directory
    || withNvshmem

    # nccl-ep links `CUDA::cuda_driver` after the `libnccl_ep.a` whole-archive, so
    # libtransformer_engine.so gets a `DT_NEEDED` on libcuda.so.1, provided by the GPU driver at
    # run time:
    # OSError: libcuda.so.1: cannot open shared object file: No such file or directory
    || withNcclEp;

  pythonImportsCheck = [
    "transformer_engine"
  ]
  ++ optionals withJax [
    "transformer_engine_jax"
  ]
  ++ optionals withPytorch [
    "transformer_engine_torch"
  ];

  # Almost all tests require GPU access
  doCheck = false;

  passthru.tests = {
    withOutNcclEp = transformer-engine.override { withNcclEp = false; };
    withMpi = transformer-engine.override { withMpi = true; };
    withPytorch = transformer-engine.override { withPytorch = true; };
    withJax = transformer-engine.override { withJax = true; };
    withNvshmem = transformer-engine.override { withNvshmem = true; };
    withCusolvermp = transformer-engine.override { withCusolvermp = true; };
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
