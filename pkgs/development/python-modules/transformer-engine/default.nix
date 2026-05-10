{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  fetchpatch,
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

  cudaSupport ? config.cudaSupport,
  cudaCapabilities ?
    if withPytorch then torch.cudaCapabilities else cudaPackages.flags.cudaCapabilities,
  withMpi ? false,
  withPytorch ? true,
  withJax ? true,
  withNvshmem ? false,
}:

let
  inherit (lib)
    cmakeFeature
    concatStringsSep
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
  version = "2.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "TransformerEngine";
    tag = "v${finalAttrs.version}";
    # Their CMakeLists.txt does not easily let us inject dependencies
    fetchSubmodules = true;
    hash = "sha256-/e11kacSYPKdjVEKAo3x/CarzKhO3tiTsMjYWLzHbls=";
  };

  patches =
    optionals cudaSupport [
      (replaceVars ./cuda-libs-paths.patch {
        libcudnn_so = "${getLib cudaPackages.cudnn}/lib/libcudnn.so";
        libnvrtc_so = "${getLib cudaPackages.cuda_nvrtc}/lib/libnvrtc.so";
        libcurand_so = "${getLib cudaPackages.libcurand}/lib/libcurand.so";

        cudart_include_dir = "${getInclude cudaPackages.cuda_cudart}/include";
      })

      # https://github.com/NVIDIA/TransformerEngine/pull/2832
      (fetchpatch {
        name = "fix-cuda-arch-cmake-logic";
        url = "https://github.com/GaetanLepage/TransformerEngine/commit/a3cf63e0d03dd9af1d494854949387f1ae677bf0.patch";
        hash = "sha256-g2aIF0fROsExEjuNiyI62/rrCOXYyOjyQIOn6rCrUyI=";
      })
    ]
    ++ optionals withNvshmem [
      # https://github.com/NVIDIA/TransformerEngine/pull/2815
      (fetchpatch {
        name = "fix-nvshmem-build";
        url = "https://github.com/NVIDIA/TransformerEngine/commit/e83c09742166dfef3f871cfa1407605feafb3afe.patch";
        hash = "sha256-5pf0Dg1XL7oAQjR1JZcdgbeaGj9qw9G5+i9Ac0iff64=";
      })
    ]
    ++ optionals (withMpi && withJax) [
      # https://github.com/NVIDIA/TransformerEngine/pull/2835
      (fetchpatch {
        name = "fix-jax-extension-build-with-mpi";
        url = "https://github.com/GaetanLepage/TransformerEngine/commit/f68cd3cab34972a899ad0069e2c4ee806e8bc6fb.patch";
        hash = "sha256-u0ljg1FwY0QjR+ETswpzWV+Sbv00JHI5CSrNQ/9zsuA=";
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
    # Harcode the path to the output store path that transformer_engine will use to import
    # - libtransformer_engine.so
    # - transformer_engine_jax.cpython-313-x86_64-linux-gnu.so
    # - transformer_engine_torch.cpython-313-x86_64-linux-gnu.so
    # This skips their impure find logic.
    + ''
      substituteInPlace transformer_engine/common/__init__.py \
        --replace-fail \
          'te_path = Path(importlib.util.find_spec("transformer_engine").origin).parent.parent' \
          'te_path = Path("${placeholder "out"}/${python.sitePackages}")'
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

    NVTE_UB_WITH_MPI = if withMpi then 1 else 0;
    # NOTE: Make sure to use mpi from buildPackages to match the spliced version created through nativeBuildInputs.
    MPI_HOME = optionalString withMpi (getLib mpi).outPath;

    NVTE_ENABLE_NVSHMEM = if withNvshmem then 1 else 0;
    NVSHMEM_HOME = optionalString withNvshmem cudaPackages.libnvshmem.outPath;
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

  # When built with nvshmem support `dlopen`ing libtransformer_engine.so `dlopen`s
  # libnvidia-ml.so.1 which is provided by the GPU driver at run time:
  # OSError: libnvidia-ml.so.1: cannot open shared object file: No such file or directory
  pythonImportsCheck = optionals (!withNvshmem) (
    [
      "transformer_engine"
    ]
    ++ optionals withJax [
      "transformer_engine_jax"
    ]
    ++ optionals withPytorch [
      "transformer_engine_torch"
    ]
  );

  # Almost all tests require GPU access
  doCheck = false;

  meta = {
    description = "Library for accelerating Transformer models on NVIDIA GPUs";
    homepage = "https://github.com/NVIDIA/TransformerEngine";
    changelog = "https://github.com/NVIDIA/TransformerEngine/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    broken = !cudaSupport;
  };
})
