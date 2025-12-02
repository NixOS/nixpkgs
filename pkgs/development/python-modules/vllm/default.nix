{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  symlinkJoin,
  autoAddDriverRunpath,

  # build system
  cmake,
  jinja2,
  ninja,
  packaging,
  setuptools,
  setuptools-scm,

  # dependencies
  which,
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
  xgrammar,
  numba,
  fastapi,
  uvicorn,
  pydantic,
  aioprometheus,
  anthropic,
  nvidia-ml-py,
  openai,
  pyzmq,
  tiktoken,
  torchaudio,
  torchvision,
  py-cpuinfo,
  lm-format-enforcer,
  prometheus-fastapi-instrumentator,
  cupy,
  cbor2,
  pybase64,
  gguf,
  einops,
  importlib-metadata,
  partial-json-parser,
  compressed-tensors,
  mistral-common,
  msgspec,
  model-hosting-container-standards,
  numactl,
  tokenizers,
  oneDNN,
  blake3,
  depyf,
  opencv-python-headless,
  cachetools,
  llguidance,
  python-json-logger,
  python-multipart,
  llvmPackages,
  opentelemetry-sdk,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  bitsandbytes,
  flashinfer,
  py-libnuma,
  setproctitle,
  openai-harmony,

  # optional-dependencies
  # audio
  librosa,
  soundfile,

  # internal dependency - for overriding in overlays
  vllm-flash-attn ? null,

  cudaSupport ? torch.cudaSupport,
  cudaPackages ? { },
  rocmSupport ? torch.rocmSupport,
  rocmPackages ? { },
  gpuTargets ? [ ],
}:

let
  inherit (lib)
    lists
    strings
    trivial
    ;

  inherit (cudaPackages) flags;

  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  # see CMakeLists.txt, grepping for CUTLASS_REVISION
  # https://github.com/vllm-project/vllm/blob/v${version}/CMakeLists.txt
  cutlass = fetchFromGitHub {
    name = "cutlass-source";
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v4.2.1";
    hash = "sha256-iP560D5Vwuj6wX1otJhwbvqe/X4mYVeKTpK533Wr5gY=";
  };

  # FlashMLA's Blackwell (SM100) kernels were developed against CUTLASS v3.9.0
  # (since https://github.com/vllm-project/FlashMLA/commit/9c5dfab6d1746b4a27af14f440e7afd5c01ece68)
  # and are currently incompatible with CUTLASS v4.x APIs. The rest of the vLLM
  # build uses a newer CUTLASS, so we package both versions.
  # See upstream issue: https://github.com/vllm-project/vllm/issues/27425
  # See git submodule commit at:
  # https://github.com/vllm-project/FlashMLA/tree/${flashmla.src.rev}/csrc
  cutlass-flashmla = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v3.9.0";
    hash = "sha256-Q6y/Z6vahASeSsfxvZDwbMFHGx8CnsF90IlveeVLO9g=";
  };

  flashmla = stdenv.mkDerivation {
    pname = "flashmla";
    # https://github.com/vllm-project/FlashMLA/blob/${src.rev}/setup.py
    version = "1.0.0";

    # grep for GIT_TAG in the following file
    # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/flashmla.cmake
    src = fetchFromGitHub {
      name = "FlashMLA-source";
      owner = "vllm-project";
      repo = "FlashMLA";
      rev = "46d64a8ebef03fa50b4ae74937276a5c940e3f95";
      hash = "sha256-jtMzWB5hKz8mJGsdK6q4YpQbGp9IrQxbwmB3a64DIl0=";
    };

    dontConfigure = true;

    # flashmla normally relies on `git submodule update` to fetch cutlass
    buildPhase = ''
      rm -rf csrc/cutlass
      ln -sf ${cutlass-flashmla} csrc/cutlass
    '';

    installPhase = ''
      cp -rva . $out
    '';
  };

  # grep for GIT_TAG in the following file
  # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/qutlass.cmake
  qutlass = fetchFromGitHub {
    name = "qutlass-source";
    owner = "IST-DASLab";
    repo = "qutlass";
    rev = "830d2c4537c7396e14a02a46fbddd18b5d107c65";
    hash = "sha256-aG4qd0vlwP+8gudfvHwhtXCFmBOJKQQTvcwahpEqC84=";
  };

  vllm-flash-attn' = lib.defaultTo (stdenv.mkDerivation {
    pname = "vllm-flash-attn";
    # https://github.com/vllm-project/flash-attention/blob/${src.rev}/vllm_flash_attn/__init__.py
    version = "2.7.2.post1";

    # grep for GIT_TAG in the following file
    # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/vllm_flash_attn.cmake
    src = fetchFromGitHub {
      name = "flash-attention-source";
      owner = "vllm-project";
      repo = "flash-attention";
      rev = "58e0626a692f09241182582659e3bf8f16472659";
      hash = "sha256-ewdZd7LuBKBV0y3AaGRWISJzjg6cu59D2OtgqoDjrbM=";
    };

    patches = [
      # fix Hopper build failure
      # https://github.com/Dao-AILab/flash-attention/pull/1719
      # https://github.com/Dao-AILab/flash-attention/pull/1723
      (fetchpatch {
        url = "https://github.com/Dao-AILab/flash-attention/commit/dad67c88d4b6122c69d0bed1cebded0cded71cea.patch";
        hash = "sha256-JSgXWItOp5KRpFbTQj/cZk+Tqez+4mEz5kmH5EUeQN4=";
      })
      (fetchpatch {
        url = "https://github.com/Dao-AILab/flash-attention/commit/e26dd28e487117ee3e6bc4908682f41f31e6f83a.patch";
        hash = "sha256-NkCEowXSi+tiWu74Qt+VPKKavx0H9JeteovSJKToK9A=";
      })
    ];

    dontConfigure = true;

    # vllm-flash-attn normally relies on `git submodule update` to fetch cutlass and composable_kernel
    buildPhase = ''
      rm -rf csrc/cutlass
      ln -sf ${cutlass} csrc/cutlass
    ''
    + lib.optionalString rocmSupport ''
      rm -rf csrc/composable_kernel;
      ln -sf ${rocmPackages.composable_kernel} csrc/composable_kernel
    '';

    installPhase = ''
      cp -rva . $out
    '';
  }) vllm-flash-attn;

  cpuSupport = !cudaSupport && !rocmSupport;

  # https://github.com/pytorch/pytorch/blob/v2.8.0/torch/utils/cpp_extension.py#L2411-L2414
  supportedTorchCudaCapabilities =
    let
      real = [
        "3.5"
        "3.7"
        "5.0"
        "5.2"
        "5.3"
        "6.0"
        "6.1"
        "6.2"
        "7.0"
        "7.2"
        "7.5"
        "8.0"
        "8.6"
        "8.7"
        "8.9"
        "9.0"
        "9.0a"
        "10.0"
        "10.0a"
        "10.1"
        "10.1a"
        "10.3"
        "10.3a"
        "12.0"
        "12.0a"
        "12.1"
        "12.1a"
      ];
      ptx = lists.map (x: "${x}+PTX") real;
    in
    real ++ ptx;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For CUDA
  supportedCudaCapabilities = lists.intersectLists flags.cudaCapabilities supportedTorchCudaCapabilities;
  unsupportedCudaCapabilities = lists.subtractLists supportedCudaCapabilities flags.cudaCapabilities;

  isCudaJetson = cudaSupport && cudaPackages.flags.isJetsonBuild;

  # Use trivial.warnIf to print a warning if any unsupported GPU targets are specified.
  gpuArchWarner =
    supported: unsupported:
    trivial.throwIf (supported == [ ]) (
      "No supported GPU targets specified. Requested GPU targets: "
      + strings.concatStringsSep ", " unsupported
    ) supported;

  # Create the gpuTargetString.
  gpuTargetString = strings.concatStringsSep ";" (
    if gpuTargets != [ ] then
      # If gpuTargets is specified, it always takes priority.
      gpuTargets
    else if cudaSupport then
      gpuArchWarner supportedCudaCapabilities unsupportedCudaCapabilities
    else if rocmSupport then
      rocmPackages.clr.gpuTargets
    else
      throw "No GPU targets specified"
  );

  mergedCudaLibraries = with cudaPackages; [
    cuda_cudart # cuda_runtime.h, -lcudart
    cuda_cccl
    libcurand # curand_kernel.h
    libcusparse # cusparse.h
    libcusolver # cusolverDn.h
    cuda_nvtx
    cuda_nvrtc
    # cusparselt # cusparseLt.h
    libcublas
  ];

  # Some packages are not available on all platforms
  nccl = shouldUsePkg (cudaPackages.nccl or null);

  getAllOutputs = p: [
    (lib.getBin p)
    (lib.getLib p)
    (lib.getDev p)
  ];

in

buildPythonPackage rec {
  pname = "vllm";
  version = "0.11.2";
  pyproject = true;

  stdenv = torch.stdenv;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "vllm";
    tag = "v${version}";
    hash = "sha256-DoSlkFmR3KKEtfSfdRB++0CZeeXgxmM3zZjONlxbe8U=";
  };

  patches = [
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
    ./0003-propagate-pythonpath.patch
    ./0005-drop-intel-reqs.patch
  ];

  postPatch = ''
    # Remove vendored pynvml entirely
    rm vllm/third_party/pynvml.py
    substituteInPlace tests/utils.py \
      --replace-fail \
        "from vllm.third_party.pynvml import" \
        "from pynvml import"
    substituteInPlace vllm/utils/import_utils.py \
      --replace-fail \
        "import vllm.third_party.pynvml as pynvml" \
        "import pynvml"

    # pythonRelaxDeps does not cover build-system
    substituteInPlace pyproject.toml \
      --replace-fail "torch ==" "torch >=" \
      --replace-fail "setuptools>=77.0.3,<81.0.0" "setuptools"

    # Ignore the python version check because it hard-codes minor versions and
    # lags behind `ray`'s python interpreter support
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(PYTHON_SUPPORTED_VERSIONS' \
        'set(PYTHON_SUPPORTED_VERSIONS "${lib.versions.majorMinor python.version}"'

    # Pass build environment PYTHONPATH to vLLM's Python configuration scripts
    substituteInPlace CMakeLists.txt \
      --replace-fail '$PYTHONPATH' '$ENV{PYTHONPATH}'
  '';

  nativeBuildInputs = [
    which
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.hipcc
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ]
  ++ lib.optionals isCudaJetson [
    cudaPackages.autoAddCudaCompatRunpath
  ];

  build-system = [
    cmake
    jinja2
    ninja
    packaging
    setuptools
    setuptools-scm
    torch
  ];

  buildInputs =
    lib.optionals cpuSupport [
      oneDNN
    ]
    ++ lib.optionals (cpuSupport && stdenv.hostPlatform.isLinux) [
      numactl
    ]
    ++ lib.optionals cudaSupport (
      mergedCudaLibraries
      ++ (with cudaPackages; [
        nccl
        cudnn
        libcufile
      ])
    )
    ++ lib.optionals rocmSupport (
      with rocmPackages;
      [
        clr
        rocthrust
        rocprim
        hipsparse
        hipblas
      ]
    )
    ++ lib.optionals stdenv.cc.isClang [
      llvmPackages.openmp
    ];

  dependencies = [
    aioprometheus
    anthropic
    blake3
    cachetools
    cbor2
    depyf
    fastapi
    llguidance
    lm-format-enforcer
    numpy
    openai
    opencv-python-headless
    outlines
    pandas
    prometheus-fastapi-instrumentator
    py-cpuinfo
    pyarrow
    pybase64
    pydantic
    python-json-logger
    python-multipart
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
    model-hosting-container-standards
    torch
    torchaudio
    torchvision
    transformers
    uvicorn
    xformers
    xgrammar
    numba
    opentelemetry-sdk
    opentelemetry-api
    opentelemetry-exporter-otlp
    bitsandbytes
    setproctitle
    openai-harmony
    # vLLM needs Torch's compiler to be present in order to use torch.compile
    torch.stdenv.cc
  ]
  ++ uvicorn.optional-dependencies.standard
  ++ aioprometheus.optional-dependencies.starlette
  ++ lib.optionals stdenv.targetPlatform.isLinux [
    py-libnuma
    psutil
  ]
  ++ lib.optionals cudaSupport [
    cupy
    nvidia-ml-py
    flashinfer
  ];

  optional-dependencies = {
    audio = [
      librosa
      soundfile
      mistral-common
    ]
    ++ mistral-common.optional-dependencies.audio;
  };

  dontUseCmakeConfigure = true;
  cmakeFlags = [
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}")
    (lib.cmakeFeature "FLASH_MLA_SRC_DIR" "${lib.getDev flashmla}")
    (lib.cmakeFeature "VLLM_FLASH_ATTN_SRC_DIR" "${lib.getDev vllm-flash-attn'}")
    (lib.cmakeFeature "QUTLASS_SRC_DIR" "${lib.getDev qutlass}")
    (lib.cmakeFeature "TORCH_CUDA_ARCH_LIST" "${gpuTargetString}")
    (lib.cmakeFeature "CUTLASS_NVCC_ARCHS_ENABLED" "${cudaPackages.flags.cmakeCudaArchitecturesString}")
    (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${symlinkJoin {
      name = "cuda-merged-${cudaPackages.cudaMajorMinorVersion}";
      paths = builtins.concatMap getAllOutputs mergedCudaLibraries;
    }}")
    (lib.cmakeFeature "CAFFE2_USE_CUDNN" "ON")
    (lib.cmakeFeature "CAFFE2_USE_CUFILE" "ON")
    (lib.cmakeFeature "CUTLASS_ENABLE_CUBLAS" "ON")
  ];

  env =
    lib.optionalAttrs cudaSupport {
      VLLM_TARGET_DEVICE = "cuda";
      CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
    }
    // lib.optionalAttrs rocmSupport {
      VLLM_TARGET_DEVICE = "rocm";
      # Otherwise it tries to enumerate host supported ROCM gfx archs, and that is not possible due to sandboxing.
      PYTORCH_ROCM_ARCH = lib.strings.concatStringsSep ";" rocmPackages.clr.gpuTargets;
      ROCM_HOME = "${rocmPackages.clr}";
    }
    // lib.optionalAttrs cpuSupport {
      VLLM_TARGET_DEVICE = "cpu";
      FETCHCONTENT_SOURCE_DIR_ONEDNN = "${oneDNN.src}";
    };

  preConfigure = ''
    # See: https://github.com/vllm-project/vllm/blob/v0.7.1/setup.py#L75-L109
    # There's also NVCC_THREADS but Nix/Nixpkgs doesn't really have this concept.
    export MAX_JOBS="$NIX_BUILD_CORES"
  '';

  pythonRelaxDeps = true;

  pythonImportsCheck = [ "vllm" ];

  passthru = {
    # make internal dependency available to overlays
    vllm-flash-attn = vllm-flash-attn';
    # updates the cutlass fetcher instead
    skipBulkUpdate = true;
  };

  meta = {
    description = "High-throughput and memory-efficient inference and serving engine for LLMs";
    changelog = "https://github.com/vllm-project/vllm/releases/tag/v${version}";
    homepage = "https://github.com/vllm-project/vllm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      happysalada
      lach
      daniel-fahey
    ];
    badPlatforms = [
      # CMake Error at cmake/cpu_extension.cmake:188 (message):
      #   vLLM CPU backend requires AVX512, AVX2, Power9+ ISA, S390X ISA, ARMv8 or
      #   RISC-V support.
      "aarch64-darwin"

      # CMake Error at cmake/cpu_extension.cmake:78 (find_isa):
      # find_isa Function invoked with incorrect arguments for function named:
      # find_isa
      "x86_64-darwin"
    ];
  };
}
