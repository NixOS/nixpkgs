{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchFromGitHub,
  symlinkJoin,

  # build system
  packaging,
  setuptools,
  wheel,

  # dependencies
  which,
  ninja,
  cmake,
  setuptools-scm,
  torch,
  outlines,
  psutil,
  ray,
  pandas,
  pyarrow,
  sentencepiece,
  numpy,
  transformers,
  xformers,
  fastapi,
  uvicorn,
  pydantic,
  aioprometheus,
  pynvml,
  openai,
  pyzmq,
  tiktoken,
  torchvision,
  py-cpuinfo,
  lm-format-enforcer,
  prometheus-fastapi-instrumentator,
  cupy,
  gguf,
  einops,
  importlib-metadata,
  partial-json-parser,
  compressed-tensors,
  mistral-common,
  msgspec,
  numactl,
  tokenizers,
  oneDNN,

  config,

  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  rocmSupport ? false,
  rocmPackages ? { },
  gpuTargets ? [ ],
}@args:

let
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "refs/tags/v3.5.1";
    sha256 = "sha256-sTGYN+bjtEqQ7Ootr/wvx3P9f8MCDSSj3qyCWjfdLEA=";
  };

  vllm-flash-attn = fetchFromGitHub {
    owner = "vllm-project";
    repo = "flash-attention";
    rev = "013f0c4fc47e6574060879d9734c1df8c5c273bd";
    sha256 = "sha256-5wYPIO9QgqpBqoL/L6dJKaSllgwldu9OeNRutDgcXvs=";
  };

  cpuSupport = !cudaSupport && !rocmSupport;

  mergedCudaLibraries = with cudaPackages; [
    cuda_cudart # cuda_runtime.h, -lcudart
    cuda_cccl
    libcusparse # cusparse.h
    libcusolver # cusolverDn.h
    cuda_nvtx
    cuda_nvrtc
    libcublas
  ];

  getAllOutputs = p: [
    (lib.getBin p)
    (lib.getLib p)
    (lib.getDev p)
  ];

in

buildPythonPackage rec {
  pname = "vllm";
  version = "0.6.3.post1";
  pyproject = true;

  stdenv = if cudaSupport then cudaPackages.backendStdenv else args.stdenv;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VHFU8EzkYRTZwm6cRmA5+YAm3NWkrYjX9ZSXUZNnkx0=";
  };

  patches = [
    ./0001-setup.py-don-t-ask-for-hipcc-version.patch
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
  ];

  # Ignore the python version check because it hard-codes minor versions and
  # lags behind `ray`'s python interpreter support
  # Relax torch dependency manually because the nonstandard requirements format
  # is not caught by pythonRelaxDeps
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(PYTHON_SUPPORTED_VERSIONS' \
        'set(PYTHON_SUPPORTED_VERSIONS "${lib.versions.majorMinor python.version}"'
    substituteInPlace requirements*.txt pyproject.toml \
      --replace-warn 'torch==2.4.0' 'torch==${lib.getVersion torch}' \
      --replace-warn 'torch == 2.4.0' 'torch == ${lib.getVersion torch}' \
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pythonRelaxDepsHook
    which
  ] ++ lib.optionals rocmSupport [ rocmPackages.hipcc ]
  ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  build-system = [
    packaging
    setuptools
    wheel
  ];

  buildInputs =
    [
      setuptools-scm
      torch
    ]
    ++ (lib.optionals cpuSupport ([
      numactl
      oneDNN
    ]))
    ++ (lib.optionals cudaSupport mergedCudaLibraries ++ (with cudaPackages; [
      cudnn
      libcufile
    ]))
    ++ (lib.optionals rocmSupport (
      with rocmPackages;
      [
        clr
        rocthrust
        rocprim
        hipsparse
        hipblas
      ]
    ));

  dependencies =
    [
      aioprometheus
      fastapi
      lm-format-enforcer
      numpy
      openai
      outlines
      pandas
      prometheus-fastapi-instrumentator
      psutil
      py-cpuinfo
      pyarrow
      pydantic
      pyzmq
      ray
      sentencepiece
      tiktoken
      tokenizers
      msgspec
      gguf
      einops
      importlib-metadata
      partial-json-parser
      compressed-tensors
      mistral-common
      torch
      torchvision
      transformers
      uvicorn
      xformers
    ]
    ++ uvicorn.optional-dependencies.standard
    ++ aioprometheus.optional-dependencies.starlette
    ++ lib.optionals cudaSupport [
      cupy
      pynvml
    ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}")
    (lib.cmakeFeature "VLLM_FLASH_ATTN_SRC_DIR" "${lib.getDev vllm-flash-attn}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONEDNN" "${lib.getDev oneDNN}")
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${symlinkJoin {
      name = "cuda-merged-${cudaPackages.cudaVersion}";
      paths = builtins.concatMap getAllOutputs mergedCudaLibraries;
    }}")
  ] ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CAFFE2_USE_CUDNN" "ON")
    (lib.cmakeFeature "CAFFE2_USE_CUFILE" "ON")
    (lib.cmakeFeature "CUTLASS_ENABLE_CUBLAS" "ON")
  ];

  env =
    lib.optionalAttrs cudaSupport {
      VLLM_TARGET_DEVICE = "cuda";
      # CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
    }
    // lib.optionalAttrs rocmSupport {
      VLLM_TARGET_DEVICE = "rocm";
      # Otherwise it tries to enumerate host supported ROCM gfx archs, and that is not possible due to sandboxing.
      PYTORCH_ROCM_ARCH = lib.strings.concatStringsSep ";" rocmPackages.clr.gpuTargets;
      ROCM_HOME = "${rocmPackages.clr}";
    }
    // lib.optionalAttrs cpuSupport {
      VLLM_TARGET_DEVICE = "cpu";
    };

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "vllm" ];

  meta = with lib; {
    description = "High-throughput and memory-efficient inference and serving engine for LLMs";
    changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
    homepage = "https://github.com/vllm-project/vllm";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      lach
    ];

    # CPU support relies on unpackaged dependency `intel_extension_for_pytorch`
    broken = cpuSupport;
  };
}
