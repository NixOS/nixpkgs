{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchFromGitHub,
  einops,
  gguf,
  which,
  ninja,
  numactl,
  cmake,
  mistral-common,
  msgspec,
  packaging,
  setuptools,
  setuptools-scm,
  torch,
  outlines,
  wheel,
  psutil,
  compressed-tensors,
  ray,
  pandas,
  partial-json-parser,
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
  torch-tb-profiler, # for kineto
  py-cpuinfo,
  lm-format-enforcer,
  prometheus-fastapi-instrumentator,
  cupy,
  writeShellScript,

  cudaPackages ? { },
  rocmPackages ? { },
  gpuTargets ? [ ],
  config,
}@args:

let
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "refs/tags/v3.5.1";
    sha256 = "sha256-sTGYN+bjtEqQ7Ootr/wvx3P9f8MCDSSj3qyCWjfdLEA=";
  };

  # See vllm/cmake/cpu_extension.cmake
  onednn = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "onednn";
    rev = "refs/tags/v3.6";
    sha256 = "sha256-x8tm+zXrHifbiealz8iUE+LtWyQHj4DgHpxLdfOairg=";
  };

  # See CMakeLists.txt, grepping for vllm-flash-attn
  vllm-flash-attn = fetchFromGitHub {
    owner = "vllm-project";
    repo = "flash-attention";
    rev = "5259c586c403a4e4d8bf69973c159b40cc346fb9";
    sha256 = "sha256-8ceXZ4/Hudz21IOlBVMtCWGMNHfe4YHwtGRBb9LCUY8=";
    fetchSubmodules = true;
  };

in
let
  target = if config.cudaSupport then "cuda" else if config.rocmSupport then "rocm" else "cpu";

  validTargets = {
    cpu = {
      buildInputs = [
        torch-tb-profiler # for kineto
      ];
      dependencies = [
        torch-tb-profiler # for kineto
      ];
      env = { };
      nativeBuildInputs = [ ];
      cmakeFlags = [
        (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONEDNN" "${lib.getDev onednn}")
      ];
    };

    cuda = {
      buildInputs = with cudaPackages; [
        cuda_cudart # cuda_runtime.h, -lcudart
        cuda_cccl
        libcusparse # cusparse.h
        libcusolver # cusolverDn.h
        cuda_nvtx
        libcublas
      ];
      dependencies = [
        cupy
        pynvml
      ];
      env = {
        CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
      };
      nativeBuildInputs = with cudaPackages; [
        cuda_nvcc
      ];
      cmakeFlags = [
        (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}")
        (lib.cmakeFeature "VLLM_FLASH_ATTN_SRC_DIR" "${lib.getDev vllm-flash-attn}")
      ];
    };

    rocm = {
      buildInputs = with rocmPackages; [
        clr
        rocthrust
        rocprim
        hipsparse
        hipblas
      ];
      dependencies = [ ];
      env = {
        # Otherwise it tries to enumerate host supported ROCM gfx archs, and that is not possible due to sandboxing.
        PYTORCH_ROCM_ARCH = lib.strings.concatStringsSep ";" rocmPackages.clr.gpuTargets;
        ROCM_HOME = "${rocmPackages.clr}";
      };
      nativeBuildInputs = [ rocmPackages.hipcc ];
      cmakeFlags = [ ];
    };
  };
in
assert (validTargets.${target} ? null) != null;

buildPythonPackage rec {
  pname = "vllm";
  version = "0.6.4";
  pyproject = true;

  stdenv = if target == "cuda" then cudaPackages.backendStdenv else args.stdenv;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6DbUAw+yp5bImyq2Acxeio7BPmwwkDYdYQhNMUX5cAY=";
  };

  patches = [
    ./0001-setup.py-don-t-ask-for-hipcc-version.patch
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
    ./0003-propagate-pythonpath.patch
    ./0004-drop-lsmod.patch
  ];

  # Ignore the python version check because it hard-codes minor versions and
  # lags behind `ray`'s python interpreter support
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(PYTHON_SUPPORTED_VERSIONS' \
        'set(PYTHON_SUPPORTED_VERSIONS "${lib.versions.majorMinor python.version}"'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pythonRelaxDepsHook
    which
  ] ++ validTargets.${target}.nativeBuildInputs;

  build-system = [
    packaging
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = validTargets.${target}.buildInputs ++ [
    numactl
  ];

  dependencies =
    validTargets.${target}.dependencies
    ++ [
      aioprometheus
      compressed-tensors
      einops
      fastapi
      gguf
      lm-format-enforcer
      mistral-common
      msgspec
      numpy
      openai
      outlines
      pandas
      partial-json-parser
      prometheus-fastapi-instrumentator
      psutil
      py-cpuinfo
      pyarrow
      pydantic
      pyzmq
      ray
      sentencepiece
      tiktoken
      torch
      torchvision
      transformers
      uvicorn
      xformers
    ]
    ++ uvicorn.optional-dependencies.standard
    ++ aioprometheus.optional-dependencies.starlette;

  dontUseCmakeConfigure = true;
  cmakeFlags = validTargets.${target}.cmakeFlags;
  dontCheckRuntimeDeps = true;
  postConfigure = ''
    # Referred to by setup.py
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  env = {
    VLLM_TARGET_DEVICE = target;
  } // validTargets.${target}.env;

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
  };
}
