{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  pythonAtLeast,
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
  pynvml,
  openai,
  pyzmq,
  tiktoken,
  torchaudio,
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

  # see CMakeLists.txt, grepping for GIT_TAG near cutlass
  # https://github.com/vllm-project/vllm/blob/v${version}/CMakeLists.txt
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v3.9.2";
    hash = "sha256-teziPNA9csYvhkG5t2ht8W8x5+1YGGbHm8VKx4JoxgI=";
  };

  flashmla = stdenv.mkDerivation {
    pname = "flashmla";
    # https://github.com/vllm-project/FlashMLA/blob/${src.rev}/setup.py
    version = "1.0.0";

    # grep for GIT_TAG in the following file
    # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/flashmla.cmake
    src = fetchFromGitHub {
      owner = "vllm-project";
      repo = "FlashMLA";
      rev = "575f7724b9762f265bbee5889df9c7d630801845";
      hash = "sha256-8WrKMl0olr0nYV4FRJfwSaJ0F5gWQpssoFMjr9tbHBk=";
    };

    dontConfigure = true;

    # flashmla normally relies on `git submodule update` to fetch cutlass
    buildPhase = ''
      rm -rf csrc/cutlass
      ln -sf ${cutlass} csrc/cutlass
    '';

    installPhase = ''
      cp -rva . $out
    '';
  };

  vllm-flash-attn' = lib.defaultTo (stdenv.mkDerivation {
    pname = "vllm-flash-attn";
    # https://github.com/vllm-project/flash-attention/blob/${src.rev}/vllm_flash_attn/__init__.py
    version = "2.7.4.post1";

    # grep for GIT_TAG in the following file
    # https://github.com/vllm-project/vllm/blob/v${version}/cmake/external_projects/vllm_flash_attn.cmake
    src = fetchFromGitHub {
      owner = "vllm-project";
      repo = "flash-attention";
      rev = "8798f27777fb57f447070301bf33a9f9c607f491";
      hash = "sha256-UTUvATGN1NU/Bc8qo078q6bEgILLmlrjL7Yk2iAJhg4=";
    };

    dontConfigure = true;

    # vllm-flash-attn normally relies on `git submodule update` to fetch cutlass and composable_kernel
    buildPhase =
      ''
        rm -rf csrc/cutlass
        ln -sf ${cutlass} csrc/cutlass
      ''
      + lib.optionalString (rocmSupport) ''
        rm -rf csrc/composable_kernel;
        ln -sf ${rocmPackages.composable_kernel} csrc/composable_kernel
      '';

    installPhase = ''
      cp -rva . $out
    '';
  }) vllm-flash-attn;

  cpuSupport = !cudaSupport && !rocmSupport;

  # https://github.com/pytorch/pytorch/blob/v2.7.0/torch/utils/cpp_extension.py#L2343-L2345
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
        "12.0"
        "12.0a"
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
    libcusparse # cusparse.h
    libcusolver # cusolverDn.h
    cuda_nvtx
    cuda_nvrtc
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
  version = "0.9.1";
  pyproject = true;

  # https://github.com/vllm-project/vllm/issues/12083
  disabled = pythonAtLeast "3.13";

  stdenv = torch.stdenv;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "vllm";
    tag = "v${version}";
    hash = "sha256-sp7rDpewTPXTVRBJHJMj+8pJDS6wAu0/OTJZwbPPqKc=";
  };

  patches = [
    (fetchpatch {
      name = "remove-unused-opentelemetry-semantic-conventions-ai-dep.patch";
      url = "https://github.com/vllm-project/vllm/commit/6a5d7e45f52c3a13de43b8b4fa9033e3b342ebd2.patch";
      hash = "sha256-KYthqu+6XwsYYd80PtfrMMjuRV9+ionccr7EbjE4jJE=";
    })
    (fetchpatch {
      name = "fall-back-to-gloo-when-nccl-unavailable.patch";
      url = "https://github.com/vllm-project/vllm/commit/aa131a94410683b0a02e74fed2ce95e6c2b6b030.patch";
      hash = "sha256-jNlQZQ8xiW85JWyBjsPZ6FoRQsiG1J8bwzmQjnaWFBg=";
    })
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
    ./0003-propagate-pythonpath.patch
    ./0004-drop-lsmod.patch
    ./0005-drop-intel-reqs.patch
  ];

  postPatch = ''
    # pythonRelaxDeps does not cover build-system
    substituteInPlace pyproject.toml \
      --replace-fail "torch ==" "torch >="

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

  nativeBuildInputs =
    [
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

  dependencies =
    [
      aioprometheus
      blake3
      cachetools
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
      pynvml
      flashinfer
    ];

  dontUseCmakeConfigure = true;
  cmakeFlags =
    [
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}")
      (lib.cmakeFeature "FLASH_MLA_SRC_DIR" "${lib.getDev flashmla}")
      (lib.cmakeFeature "VLLM_FLASH_ATTN_SRC_DIR" "${lib.getDev vllm-flash-attn'}")
      (lib.cmakeFeature "TORCH_CUDA_ARCH_LIST" "${gpuTargetString}")
      (lib.cmakeFeature "CUTLASS_NVCC_ARCHS_ENABLED" "${cudaPackages.flags.cmakeCudaArchitecturesString}")
      (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${symlinkJoin {
        name = "cuda-merged-${cudaPackages.cudaMajorMinorVersion}";
        paths = builtins.concatMap getAllOutputs mergedCudaLibraries;
      }}")
      (lib.cmakeFeature "CAFFE2_USE_CUDNN" "ON")
      (lib.cmakeFeature "CAFFE2_USE_CUFILE" "ON")
      (lib.cmakeFeature "CUTLASS_ENABLE_CUBLAS" "ON")
    ]
    ++ lib.optionals cpuSupport [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONEDNN" "${lib.getDev oneDNN}")
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
    ];
    badPlatforms = [
      # CMake Error at cmake/cpu_extension.cmake:78 (find_isa):
      # find_isa Function invoked with incorrect arguments for function named:
      # find_isa
      "x86_64-darwin"
    ];
  };
}
