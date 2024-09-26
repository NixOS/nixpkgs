{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  python,

  # nativeBuildInputs
  cmake,
  git,
  ninja,
  which,

  # build-system
  packaging,
  setuptools,

  # dependencies
  aiohttp,
  aioprometheus,
  fastapi,
  filelock,
  gguf,
  importlib-metadata,
  lm-format-enforcer,
  mistral-common,
  msgspec,
  numpy,
  openai,
  outlines,
  pandas,
  partial-json-parser,
  pillow,
  prometheus-client,
  prometheus-fastapi-instrumentator,
  protobuf,
  psutil,
  pyarrow,
  py-cpuinfo,
  pyyaml,
  pydantic,
  pyzmq,
  ray,
  requests,
  sentencepiece,
  tiktoken,
  tokenizers,
  torchvision,
  transformers,
  tqdm,
  uvicorn,
  xformers,
  cupy,
  pynvml,
  torchWithCuda,
  vllm-flash-attn,
  torchWithRocm,

  config,

  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },

  # Has to be either rocm or cuda, default to the free one
  rocmSupport ? !config.cudaSupport,
  rocmPackages ? { },
  gpuTargets ? [ ],
}@args:

let
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "refs/tags/v3.5.0";
    hash = "sha256-D/s7eYsa5l/mfx73tE4mnFcTQdYqGmXa9d9TCryw4e4=";
  };
in

buildPythonPackage rec {
  pname = "vllm";
  version = "0.6.1.post2";
  pyproject = true;

  stdenv = if cudaSupport then cudaPackages.backendStdenv else args.stdenv;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "vllm";
    rev = "refs/tags/v${version}";
    hash = "sha256-eRtnQTeEi0elrubkH+aMlwuXGT83Coe29JHyeIdRMhg=";
    leaveDotGit = true;
  };

  patches = [
    ./0001-setup.py-don-t-ask-for-hipcc-version.patch
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
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
    git
    ninja
    which
  ] ++ lib.optionals rocmSupport [ rocmPackages.hipcc ];

  build-system = [
    packaging
    setuptools
  ];

  buildInputs =
    (lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cudart # cuda_runtime.h, -lcudart
        cuda_cccl
        libcusparse # cusparse.h
        libcusolver # cusolverDn.h
        cuda_nvcc
        cuda_nvtx
        libcublas
      ]
    ))
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
      aiohttp
      aioprometheus
      fastapi
      filelock
      gguf
      importlib-metadata
      lm-format-enforcer
      mistral-common
      msgspec
      numpy
      openai
      outlines
      pandas
      partial-json-parser
      pillow
      prometheus-client
      prometheus-fastapi-instrumentator
      protobuf
      psutil
      pyarrow
      py-cpuinfo
      pydantic
      pyyaml
      pyzmq
      ray
      requests
      sentencepiece
      tiktoken
      tokenizers
      torchvision
      tqdm
      transformers
      uvicorn
      xformers
    ]
    ++ uvicorn.optional-dependencies.standard
    ++ aioprometheus.optional-dependencies.starlette
    ++ lib.optionals cudaSupport [
      cupy
      pynvml
      torchWithCuda
      vllm-flash-attn
    ]
    ++ lib.optionals rocmSupport [
      torchWithRocm
    ];

  dontUseCmakeConfigure = true;
  cmakeFlags = [ (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}") ];

  env =
    lib.optionalAttrs cudaSupport {
      CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
      VLLM_TARGET_DEVICE = "cuda";
    }
    // lib.optionalAttrs rocmSupport {
      # Otherwise it tries to enumerate host supported ROCM gfx archs, and that is not possible due to sandboxing.
      PYTORCH_ROCM_ARCH = lib.strings.concatStringsSep ";" rocmPackages.clr.gpuTargets;
      ROCM_HOME = "${rocmPackages.clr}";
      VLLM_TARGET_DEVICE = "rocm";
    };

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "vllm" ];

  passthru = {
    inherit cutlass;
  };

  meta = with lib; {
    description = "High-throughput and memory-efficient inference and serving engine for LLMs";
    changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
    homepage = "https://github.com/vllm-project/vllm";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      lach
    ];
    broken = (!cudaSupport && !rocmSupport) || (cudaSupport && rocmSupport);
  };
}
