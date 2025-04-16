{
  lib,
  stdenv,
  python,
  buildPythonPackage,
  pythonRelaxDepsHook,
  fetchFromGitHub,
  symlinkJoin,
  autoAddDriverRunpath,

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
  python-multipart,
  python-amdsmi,

  awscli,
  boto3,
  botocore,
  peft,
  pytest-asyncio,
  #tensorizer,

  config,

  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  gpuTargets ? [ ],
}@args:

let
  inherit (lib)
    lists
    strings
    trivial
    ;

  inherit (cudaPackages) cudaFlags;

  shouldUsePkg =
    pkg: if pkg != null && lib.meta.availableOn stdenv.hostPlatform pkg then pkg else null;

  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = with rocmPackages; [
      rocm-core
      clr
      rccl
      miopen
      aotriton
      rocrand
      rocblas
      rocsparse
      hipsparse
      rocthrust
      rocprim
      hipcub
      roctracer
      rocfft
      rocsolver
      hipfft
      hiprand
      hipsolver
      hipblas-common
      hipblas
      hipblaslt
      rocminfo
      rocm-comgr
      rocm-device-libs
      rocm-runtime
      clr.icd
      hipify
      amdsmi
    ];

    # Fix `setuptools` not being found
    postBuild = ''
      rm -rf $out/nix-support
    '';
  };

  # see CMakeLists.txt, grepping for GIT_TAG near cutlass
  # https://github.com/vllm-project/vllm/blob/${version}/CMakeLists.txt
  cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v3.7.0";
    hash = "sha256-GUTRXmv3DiM/GN5Bvv2LYovMLKZMlMhoKv4O0g627gs=";
  };

  vllm-flash-attn = stdenv.mkDerivation {
    pname = "vllm-flash-attn";
    # https://github.com/vllm-project/flash-attention/blob/${src.rev}/vllm_flash_attn/__init__.py
    version = "2.7.2.post1";

    # see CMakeLists.txt, grepping for GIT_TAG near vllm-flash-attn
    # https://github.com/vllm-project/vllm/blob/${version}/CMakeLists.txt
    src = fetchFromGitHub {
      owner = "vllm-project";
      repo = "flash-attention";
      rev = "720c94869cf2e0ff5a706e9c7f1dce0939686ade";
      hash = "sha256-UXbBfzBCOBjRRAAOhIzt0E27VjC6xu4G1CkZfu9LKRs=";
    };

    dontConfigure = true;

    # vllm-flash-attn normally relies on `git submodule update` to fetch cutlass
    buildPhase = ''
      rm -rf csrc/cutlass
      ln -sf ${cutlass} csrc/cutlass
    '';

    installPhase = ''
      cp -rva . $out
    '';
  };

  cpuSupport = !cudaSupport && !rocmSupport;

  # https://github.com/pytorch/pytorch/blob/v2.4.0/torch/utils/cpp_extension.py#L1953
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
      ];
      ptx = lists.map (x: "${x}+PTX") real;
    in
    real ++ ptx;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For CUDA
  supportedCudaCapabilities = lists.intersectLists cudaFlags.cudaCapabilities supportedTorchCudaCapabilities;
  unsupportedCudaCapabilities = lists.subtractLists supportedCudaCapabilities cudaFlags.cudaCapabilities;

  isCudaJetson = cudaSupport && cudaPackages.cudaFlags.isJetsonBuild;

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
  version = "0.7.3";
  pyproject = true;

  stdenv = if cudaSupport then cudaPackages.backendStdenv else args.stdenv;

  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-gudlikAjwZNkniKRPJYm7beoti8eHp5LaRV2/UNEibo=";
  };

  patches = [
    ./0002-setup.py-nix-support-respect-cmakeFlags.patch
    ./0003-propagate-pythonpath.patch
    ./0004-drop-lsmod.patch
  ];

  # Ignore the python version check because it hard-codes minor versions and
  # lags behind `ray`'s python interpreter support
  postPatch =
    ''
      substituteInPlace csrc/quantization/compressed_tensors/int8_quant_kernels.cu \
        --replace-fail \
        'dst = std::clamp(dst, i8_min, i8_max);' \
        'dst = (dst < i8_min) ? i8_min : (dst > i8_max) ? i8_max : dst;' \
        --replace-fail \
        'int32_t dst = std::clamp(x, i8_min, i8_max);' \
        'int32_t dst = (x < i8_min) ? i8_min : (x > i8_max) ? i8_max : x;'


      substituteInPlace csrc/quantization/fused_kernels/quant_conversions.cuh \
        --replace-fail \
        'dst = std::clamp(dst, i8_min, i8_max);' \
        'dst = (dst < i8_min) ? i8_min : (dst > i8_max) ? i8_max : dst;'

      substituteInPlace cmake/utils.cmake \
        --replace-fail \
        'COMMAND ''${CMAKE_SOURCE_DIR}/cmake/hipify.py' \
        'COMMAND python ''${CMAKE_SOURCE_DIR}/cmake/hipify.py' \

      substituteInPlace CMakeLists.txt \
        --replace-fail \
          'set(PYTHON_SUPPORTED_VERSIONS' \
          'set(PYTHON_SUPPORTED_VERSIONS "${lib.versions.majorMinor python.version}"'

      # Here I just took some random comment and added the line I want.
      # This really needs to be a patch.
      # I have _no_ idea how vllm builds on FHS systems. I don't see how torch
      # causes vllm to find HIP. Let's just tell cmake to find HIP.
      substituteInPlace CMakeLists.txt \
        --replace-fail \
          '# Forward the non-CUDA device extensions to external CMake scripts.' \
          'find_package(HIP REQUIRED)'

      substituteInPlace setup.py \
        --replace-fail \
        'and torch.version.hip is not None' \
        ' '

      # Instead of getting the version number via looking at the .so, let's
      # just use the version via the Nix expression.
      substituteInPlace setup.py \
        --replace-fail \
        'rocm_version = get_rocm_version()' \
        'rocm_version = "${rocmPackages.rocm-core.version}"'

      # Relax torch dependency manually because the nonstandard requirements format
      # is not caught by pythonRelaxDeps
      substituteInPlace requirements*.txt pyproject.toml \
        --replace-warn 'torch==2.5.1' 'torch==${lib.getVersion torch}' \
        --replace-warn 'torch == 2.5.1' 'torch == ${lib.getVersion torch}'
    ''
    + lib.optionalString (nccl == null) ''
      # On platforms where NCCL is not supported (e.g. Jetson), substitute Gloo (provided by Torch)
      substituteInPlace vllm/distributed/parallel_state.py \
        --replace-fail '"nccl"' '"gloo"'
    '';

  nativeBuildInputs =
    [
      cmake
      ninja
      pythonRelaxDepsHook
      which
    ]
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
      autoAddDriverRunpath
    ]
    ++ lib.optionals isCudaJetson [
      cudaPackages.autoAddCudaCompatRunpath
    ];

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
    ++ (
      lib.optionals cudaSupport mergedCudaLibraries
      ++ (with cudaPackages; [
        nccl
        cudnn
        libcufile
      ])
    )
    ++ (lib.optionals rocmSupport [ rocmtoolkit_joined ]);

  dependencies =
    [
      aioprometheus
      blake3
      depyf
      fastapi
      lm-format-enforcer
      numpy
      openai
      opencv-python-headless
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
      torchaudio
      torchvision
      transformers
      uvicorn
      xformers
      xgrammar
      numba
      python-multipart

      awscli
      boto3
      botocore
      peft
      pytest-asyncio
      #tensorizer
    ]
    ++ uvicorn.optional-dependencies.standard
    ++ aioprometheus.optional-dependencies.starlette
    ++ lib.optionals cudaSupport [
      cupy
      pynvml
    ]
    ++ lib.optionals rocmSupport [
      python-amdsmi
    ];

  dontUseCmakeConfigure = true;
  cmakeFlags =
    [
      (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${lib.getDev cutlass}")
      (lib.cmakeFeature "VLLM_FLASH_ATTN_SRC_DIR" "${lib.getDev vllm-flash-attn}")
    ]
    ++ lib.optionals rocmSupport [
      (lib.cmakeFeature "CMAKE_HIP_COMPILER" "${rocmPackages.clr.hipClangPath}/clang++")
      # TODO: this should become `clr.gpuTargets` in the future.
      #(lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" rocmPackages.rocblas.amdgpu_targets)
      (lib.cmakeFeature "CMAKE_HIP_ARCHITECTURES" "gfx1100")
      (lib.cmakeFeature "AMDGPU_TARGETS" "gfx1100")
    ]
    ++ lib.optionals cudaSupport [
      (lib.cmakeFeature "TORCH_CUDA_ARCH_LIST" "${gpuTargetString}")
      (lib.cmakeFeature "CUTLASS_NVCC_ARCHS_ENABLED" "${cudaPackages.cudaFlags.cmakeCudaArchitecturesString
      }")
      (lib.cmakeFeature "CUDA_TOOLKIT_ROOT_DIR" "${symlinkJoin {
        name = "cuda-merged-${cudaPackages.cudaVersion}";
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
      #PYTORCH_ROCM_ARCH = lib.strings.concatStringsSep ";" rocmPackages.clr.gpuTargets;
      PYTORCH_ROCM_ARCH = "gfx1100";
      ROCM_PATH = "${rocmtoolkit_joined}";
      ROCM_HOME = "${rocmtoolkit_joined}";
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

  # The runtime check is checking for tensorizer, which isn't packages, AFAIK.
  dontCheckRuntimeDeps = true;
  pythonImportsCheck = [ "vllm" ];

  # updates the cutlass fetcher instead
  passthru.skipBulkUpdate = true;

  postFixup =
    # expose runtime libraries necessary to use the gpu
    lib.optionalString rocmSupport ''
      wrapProgram "$out/bin/vllm" --set-default ROCM_PATH '${rocmtoolkit_joined}'
    '';

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
