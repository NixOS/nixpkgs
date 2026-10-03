{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  symlinkJoin,
  autoAddDriverRunpath,

  # nativeBuildInputs
  which,
  rustPlatform,
  cargo,
  rustc,
  protobuf,
  pkg-config,
  openssl,

  # build-system
  cmake,
  grpcio-tools,
  jinja2,
  ninja,
  packaging,
  setuptools,
  setuptools-scm,
  setuptools-rust,

  # buildInputs
  onednn,
  numactl,
  llvmPackages,

  # dependencies
  aioprometheus,
  anthropic,
  bitsandbytes,
  blake3,
  cachetools,
  cbor2,
  compressed-tensors,
  depyf,
  einops,
  fastapi,
  grpcio,
  grpcio-reflection,
  ijson,
  importlib-metadata,
  kaldi-native-fbank,
  llguidance,
  lm-format-enforcer,
  mcp,
  mistral-common,
  model-hosting-container-standards,
  msgspec,
  numba,
  numpy,
  openai,
  openai-harmony,
  opencv-python-headless,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions-ai,
  outlines,
  pandas,
  partial-json-parser,
  prometheus-fastapi-instrumentator,
  psutil,
  py-cpuinfo,
  pyarrow,
  pybase64,
  pydantic,
  python-json-logger,
  python-multipart,
  pyzmq,
  ray,
  sentencepiece,
  setproctitle,
  tiktoken,
  tokenizers,
  torch,
  torchaudio,
  torchvision,
  transformers,
  uvicorn,
  xgrammar,
  # linux-only
  py-libnuma,
  # cuda-only
  cupy,
  flashinfer-python,
  nvidia-ml-py,
  tokenspeed-mla,
  # cuda or rocm only
  xformers,
  # rocm-only
  amd-aiter,
  amd-quark,
  amdsmi,
  bash,
  datasets,
  peft,
  timm,

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
  emptyDevice ? false,
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
    tag = "v4.4.2";
    hash = "sha256-0q9Ad0Z6E/rO2PdM4uQc8H0E0qs9uKc3reHepiHhjEc=";
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
    rev = "147f5673d0c1c3dcf66f78d677fd647e4a020219";
    hash = "sha256-dHQto08IwTDOIuFUp9jwm1MWkFi8v2YJ/UESrLuG71g=";
  };

  # grep for DEEPGEMM_UPSTREAM_TAG in the following file
  # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/deepgemm.cmake
  deepgemm = fetchFromGitHub {
    owner = "deepseek-ai";
    repo = "DeepGEMM";
    rev = "a6b593d2826719dcf4892609af7b84ee23aaf32a";
    hash = "sha256-Kym2OAIBsx0mxWHY32bkifgPOzpuPgOu1d79ynHQHEs=";
    fetchSubmodules = true;
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
      rev = "a8f794d1251cbfd88a5011445dd5582289c727e4";
      hash = "sha256-k/Mbc70U8wbP4BHnxZ/I607Dc2EnIkhWYd9iKUG740Y=";
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
  # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/fmha_sm100.cmake
  fmha-sm100 = fetchFromGitHub {
    owner = "vllm-project";
    repo = "MSA";
    rev = "2e63ec37a0fc29bc20f39cd1a52e0f5affc33a73";
    hash = "sha256-TFW3THDfTn8Uf91+BhcY6ApU1jxxvzs5m0oxJ+kzgdM=";
    fetchSubmodules = true;
  };

  # grep for DEFAULT_TRITON_KERNELS_TAG in the following file
  # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/triton_kernels.cmake
  triton-kernels = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton";
    tag = "v3.6.0";
    hash = "sha256-JFSpQn+WsNnh7CAPlcpOcUp0nyKXNbJEANdXqmkt4Tc=";
  };

  # grep for GIT_TAG in the following file
  # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/tml_fa4.cmake
  tml-fa4 = fetchFromGitHub {
    name = "tml-fa4-source";
    owner = "vllm-project";
    repo = "tml-fa4";
    rev = "b206834606ed5b5f21f8eed6b0683f528ea9cf7d";
    hash = "sha256-LDA5bW4Bf5+w41K9aJ5flz372hy+Ukm//RT55L7nbbU=";
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
      rev = "caaa4eb59845388a20b1f435ecaafb4bd9517ad8";
      hash = "sha256-oPCjHhjRuUVarnlIn17ZqSgvDOlDZqYYZjKyAQsBMP0=";
    };

    patches = [
      # fix Hopper build failure
      # https://github.com/Dao-AILab/flash-attention/pull/1719
      (fetchpatch {
        url = "https://github.com/Dao-AILab/flash-attention/commit/dad67c88d4b6122c69d0bed1cebded0cded71cea.patch";
        hash = "sha256-JSgXWItOp5KRpFbTQj/cZk+Tqez+4mEz5kmH5EUeQN4=";
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

  cpuSupport = !cudaSupport && !rocmSupport && !emptyDevice;

  # https://github.com/pytorch/pytorch/blob/v2.9.1/torch/utils/cpp_extension.py#L2407-L2410
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
        "10.3"
        "10.3a"
        "11.0"
        "11.0a"
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
      rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets
    else
      throw "No GPU targets specified"
  );

  mergedCudaLibraries = with cudaPackages; [
    cuda_cudart # cuda_runtime.h, -lcudart
    cccl
    libcurand # curand_kernel.h
    libcusparse # cusparse.h
    libcusolver # cusolverDn.h
    cuda_nvtx
    cuda_nvrtc
    # cusparselt # cusparseLt.h
    libcublas
  ];

  # header path ends up missing rocthrust & its deps
  rocmExtraIncludeFlags = lib.concatMapStringsSep " " (pkg: "-I${lib.getInclude pkg}/include") [
    rocmPackages.rocthrust
    rocmPackages.rocprim
    rocmPackages.hipcub
  ];

  # Some packages are not available on all platforms
  nccl = shouldUsePkg (cudaPackages.nccl or null);

  getAllOutputs = p: [
    (lib.getBin p)
    (lib.getLib p)
    (lib.getDev p)
  ];

in

buildPythonPackage.override { stdenv = torch.stdenv; } (finalAttrs: {
  pname = "vllm";
  version = "0.26.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "vllm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jFzV6vQX88FhemF98HmT5j3t6Trj5lXVlym4WD/X+Kw=";
  };

  cargoRoot = "rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-/kRtossDL0xuOYEzHA6xwN3P55kn6j0+eSm7j75e2ao=";
  };

  patches = [
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
    ./0003-propagate-pythonpath.patch
    ./0005-drop-intel-reqs.patch
    ./0006-drop-rocm-extra-reqs.patch
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

    substituteInPlace tools/build_rust.py \
      --replace-fail 'features=["native-tls-vendored"],' ""
  '';

  # fastapi and many other packages are pinned strictly in vllm
  pythonRelaxDeps = true;

  pythonRemoveDeps = [
    # Not packaged in nixpkgs.
    "flashinfer-cubin"
    "nvidia-cudnn-frontend"
    "apache-tvm-ffi" # vllm does not depend on it directly, its version is only pinned for compatibility with tilelang (also removed).
    "tilelang"
    "fastsafetensors"

    # QuACK and Cutlass DSL seem to be added only for FA4
    # which in our case handles its own deps
    "nvidia-cutlass-dsl"
    "quack-kernels"

    # Optional Humming kernels for quantization
    "humming-kernels"
  ];

  nativeBuildInputs = [
    which
    rustPlatform.cargoSetupHook
    cargo
    rustc
    protobuf
    pkg-config
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
    grpcio-tools
    jinja2
    ninja
    packaging
    setuptools
    setuptools-scm
    setuptools-rust
    torch
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals cpuSupport [
    onednn
    # libgomp.so
    (lib.getLib torch.stdenv.cc.cc)
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
      rocrand
      hiprand
      rocblas
      miopen-hip
      hipfft
      hipcub
      hipsolver
      rocsolver
      hipblaslt
      rocm-runtime
      rccl
      rocshmem
      rocm-smi
      hipsparselt
    ]
  )
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  dependencies = [
    aioprometheus
    anthropic
    bitsandbytes
    blake3
    cachetools
    cbor2
    compressed-tensors
    depyf
    einops
    fastapi
    grpcio
    grpcio-reflection
    ijson
    importlib-metadata
    kaldi-native-fbank
    llguidance
    lm-format-enforcer
    mcp
    mistral-common
    model-hosting-container-standards
    msgspec
    numba
    numpy
    openai
    openai-harmony
    opencv-python-headless
    opentelemetry-api
    opentelemetry-exporter-otlp
    opentelemetry-sdk
    opentelemetry-semantic-conventions-ai
    outlines
    pandas
    partial-json-parser
    prometheus-fastapi-instrumentator
    psutil
    py-cpuinfo
    pyarrow
    pybase64
    pydantic
    python-json-logger
    python-multipart
    pyzmq
    ray
    sentencepiece
    setproctitle
    tiktoken
    tokenizers
    torch
    # vLLM needs Torch's compiler to be present in order to use torch.compile
    torch.stdenv.cc
    torchaudio
    torchvision
    transformers
    uvicorn
    xgrammar
  ]
  ++ uvicorn.optional-dependencies.standard
  ++ aioprometheus.optional-dependencies.starlette
  ++ lib.optionals stdenv.targetPlatform.isLinux [
    py-libnuma
  ]
  ++ lib.optionals cudaSupport [
    cupy
    flashinfer-python
    nvidia-ml-py
    tokenspeed-mla
  ]
  ++ lib.optionals (cudaSupport || rocmSupport) [
    xformers # Only depended on by Pixtral. Removed in vllm-project/vllm#52185.
  ]
  ++ lib.optionals rocmSupport [
    amd-aiter
    amd-quark
    rocmPackages.rocminfo
    amdsmi
    datasets
    peft
    timm
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
    (lib.cmakeFeature "DEEPGEMM_SRC_DIR" "${lib.getDev deepgemm}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}")
    (lib.cmakeFeature "FLASH_MLA_SRC_DIR" "${lib.getDev flashmla}")
    (lib.cmakeFeature "FMHA_SM100_SRC_DIR" "${lib.getDev fmha-sm100}")
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

  env = {
    VLLM_REQUIRE_RUST_FRONTEND = "1";
    VLLM_VERSION_OVERRIDE = finalAttrs.version;
  }
  // lib.optionalAttrs cudaSupport {
    VLLM_TARGET_DEVICE = "cuda";
    CUDA_HOME = "${lib.getDev cudaPackages.cuda_nvcc}";
    TRITON_KERNELS_SRC_DIR = "${lib.getDev triton-kernels}/python/triton_kernels/triton_kernels";
    TML_FA4_SRC_DIR = "${lib.getDev tml-fa4}";
  }
  // lib.optionalAttrs rocmSupport {
    VLLM_TARGET_DEVICE = "rocm";
    PYTORCH_ROCM_ARCH = gpuTargetString;
    # vLLM's CMake logic checks `ROCM_PATH` to decide whether HIP/ROCm is available.
    ROCM_PATH = "${rocmPackages.clr}";
    TRITON_KERNELS_SRC_DIR = "${lib.getDev triton-kernels}/python/triton_kernels/triton_kernels";
    HIPFLAGS = rocmExtraIncludeFlags;
    CXXFLAGS = rocmExtraIncludeFlags;
  }
  // lib.optionalAttrs cpuSupport {
    VLLM_TARGET_DEVICE = "cpu";
    VLLM_VERSION_OVERRIDE = "${finalAttrs.version}+cpu";
    FETCHCONTENT_SOURCE_DIR_ONEDNN = "${onednn.src}";
  }
  // lib.optionalAttrs emptyDevice {
    VLLM_TARGET_DEVICE = "empty";
  };

  preConfigure = ''
    # See: https://github.com/vllm-project/vllm/blob/v0.7.1/setup.py#L75-L109
    # There's also NVCC_THREADS but Nix/Nixpkgs doesn't really have this concept.
    export MAX_JOBS="$NIX_BUILD_CORES"
  '';

  pythonImportsCheck = [ "vllm" ];

  # vLLM detects the CPU platform from the "+cpu" suffix.
  dontCheckPythonMetadata = cpuSupport;

  makeWrapperArgs =
    lib.optionals (cudaSupport && cudaPackages ? nccl) [
      "--set"
      "VLLM_NCCL_SO_PATH"
      "${cudaPackages.nccl}/lib/libnccl.so"
    ]
    ++ lib.optionals rocmSupport [
      "--set"
      "HIP_DEVICE_LIB_PATH"
      "${rocmPackages.rocm-device-libs}/amdgcn/bitcode"

      "--prefix"
      "PATH"
      ":"
      "${rocmPackages.clr}/bin:${bash}/bin"
    ];

  passthru = {
    # make internal dependency available to overlays
    vllm-flash-attn = vllm-flash-attn';
    # updates the cutlass fetcher instead
    skipBulkUpdate = true;
  };

  meta = {
    description = "High-throughput and memory-efficient inference and serving engine for LLMs";
    changelog = "https://github.com/vllm-project/vllm/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/vllm-project/vllm";
    license = lib.licenses.asl20;
    mainProgram = "vllm";
    maintainers = with lib.maintainers; [
      happysalada
      lach
      daniel-fahey
      LunNova # esp. for ROCm
    ];
    badPlatforms = [
      # error: could not find git for clone of arm_compute-populate
      "aarch64-linux"

      # CMake Error at cmake/cpu_extension.cmake:188 (message):
      #   vLLM CPU backend requires AVX512, AVX2, Power9+ ISA, S390X ISA, ARMv8 or
      #   RISC-V support.
      "aarch64-darwin"
    ];
    broken = cudaSupport;
  };
})
