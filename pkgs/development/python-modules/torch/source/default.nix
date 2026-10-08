{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  git-unroll,
  buildPythonPackage,
  buildPackages,
  python,
  runCommand,
  writeShellScript,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,
  effectiveMagma ?
    if cudaSupport then
      magma-cuda-static.override { inherit cudaPackages; }
    else if rocmSupport then
      magma-hip
    else
      magma,
  magma,
  magma-hip,
  magma-cuda-static,
  # Use the system NCCL as long as we're targeting CUDA on a supported platform.
  useSystemNccl ? (cudaSupport && cudaPackages.nccl.meta.available || rocmSupport),
  withNvshmem ? (cudaSupport && cudaPackages.libnvshmem.meta.available),
  withTensorboard ? false,
  MPISupport ? false,
  mpi,
  buildDocs ? false,
  pkgsHostHost,

  # tests.cudaAvailable:
  callPackage,

  # build-system
  cmake,
  ninja,
  numpy,
  packaging,
  pyyaml,
  requests,
  six,

  # nativeBuildInputs
  symlinkJoin,
  which,
  pybind11,
  pkg-config,
  removeReferencesTo,

  # buildInputs
  openssl,
  numactl,
  llvmPackages,

  # dependencies
  filelock,
  fsspec,
  jinja2,
  networkx,
  setuptools,
  sympy,
  typing-extensions,

  binutils,
  hypothesis,
  psutil,
  # ROCm build and `torch.compile` requires `triton`
  tritonSupport ? (lib.meta.availableOn stdenv.hostPlatform triton),
  triton,

  # TODO: 1. callPackage needs to learn to distinguish between the task
  #          of "asking for an attribute from the parent scope" and
  #          the task of "exposing a formal parameter in .override".
  # TODO: 2. We should probably abandon attributes such as `torchWithCuda` (etc.)
  #          as they routinely end up consuming the wrong arguments\
  #          (dependencies without cuda support).
  #          Instead we should rely on overlays and nixpkgsFun.
  # (@SomeoneSerge)
  _tritonEffective ? if cudaSupport then triton-cuda.override { inherit cudaPackages; } else triton,
  triton-cuda,

  # Disable MKLDNN on aarch64-darwin, it negatively impacts performance,
  # this is also what official pytorch build does
  mklDnnSupport ? !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64),

  # virtual pkg that consistently instantiates blas across nixpkgs
  # See https://github.com/NixOS/nixpkgs/pull/83888
  blas,

  # dependencies for torch.utils.tensorboard
  pillow,
  tensorboard,
  protobuf,

  # ROCm dependencies
  rocmSupport ? config.rocmSupport,
  rocmPackages,
  gpuTargets ? [ ],

  vulkanSupport ? false,
  vulkan-headers,
  vulkan-loader,
  shaderc,
}:

let
  inherit (lib)
    attrsets
    lists
    strings
    trivial
    ;
  inherit (cudaPackages) cudnn flags nccl;

  cudaInputs = lib.optionals cudaSupport (
    with cudaPackages;
    [
      cccl # <thrust/*>
      cuda_cudart # cuda_runtime.h, propagated CRT headers, and libraries
      cuda_cupti # For kineto
      cuda_nvml_dev # <nvml.h>
      cuda_nvrtc
      cuda_nvtx # -llibNVToolsExt
      libcublas
      libcufft
      libcufile
      libcurand
      libcusolver
      libcusparse
      libcusparse_lt
    ]
    ++ lists.optionals (cudaPackages ? cudnn) [ cudnn ]
    ++ lists.optionals useSystemNccl [
      # Some platforms do not support NCCL (i.e., Jetson)
      nccl # Provides nccl.h
      (lib.getOutput "static" nccl) # Link-only archive; nccl above provides headers.
    ]
    ++ lists.optionals withNvshmem [
      cudaPackages.libnvshmem
    ]
    ++ [
      cuda_profiler_api # <cuda_profiler_api.h>
    ]
  );

  # Derive installed JIT paths before mkDerivation projects inputs to dev.
  # Explicit static archive inputs are link-only; their package's ordinary
  # input above supplies the public headers and shared-library interface.
  cudaPublicInputs = map (input: input.__spliced.hostTarget or input) (
    lib.filter (
      input: !(input.outputSpecified or false) || (input.outputName or "") != "static"
    ) cudaInputs
  );
  cudaIncludeFlags = lib.concatMapStringsSep " " (
    input:
    let
      include =
        if input ? outputInclude then lib.getOutput input.outputInclude input else lib.getInclude input;
    in
    "-I${include}/include"
  ) cudaPublicInputs;
  cudaLibraryDirs = lib.concatMapStringsSep " " (
    input: "${lib.getOutput (input.outputLib or "lib") input}/lib"
  ) cudaPublicInputs;

  # Inductor loads its generated code in the running HOST process. Select the
  # HOST -> HOST compiler before extracting the nested stdenv.cc attribute.
  runtimeCC = pkgsHostHost.targetPackages.stdenv.cc;

  triton = throw "python3Packages.torch: use _tritonEffective instead of triton to avoid divergence";

  setBool = v: if v then "1" else "0";

  isCudaJetson = cudaSupport && cudaPackages.flags.isJetsonBuild;

  # Create the gpuTargetString.
  gpuTargetString = strings.concatStringsSep ";" (
    if gpuTargets != [ ] then
      # If gpuTargets is specified, it always takes priority.
      gpuTargets
    else if cudaSupport then
      # The CUDA scope validates toolkit support. Torch's CMake parser accepts
      # numeric targets (including a/f suffixes); its Python JIT allowlist is a
      # separate interface and must not silently narrow the package build.
      flags.cudaCapabilities
    else if rocmSupport then
      lib.lists.subtractLists [
        # Remove RDNA1 gfx101x archs from default ROCm support list to avoid
        # use of undeclared identifier 'CK_BUFFER_RESOURCE_3RD_DWORD'
        # TODO: Retest after ROCm 6.4 or torch 2.8
        "gfx1010"
        "gfx1012"
      ] rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets
    else
      throw "No GPU targets specified"
  );

  # Use vendored CK as header only dep if rocmPackages' CK doesn't properly support targets
  vendorComposableKernel = rocmSupport && !rocmPackages.composable_kernel.anyMfmaTarget;

  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths =
      with rocmPackages;
      [
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
        rocm-smi
        clr.icd
        hipify
        rocprofiler-sdk
        rocprofiler-sdk.dev
        amdsmi
      ]
      ++ lib.optionals (!vendorComposableKernel) [
        composable_kernel
      ];

    # Fix `setuptools` not being found
    postBuild = ''
      rm -rf $out/nix-support
    '';
  };

  brokenConditions = attrsets.filterAttrs (_: cond: cond) {
    "CUDA and ROCm are mutually exclusive" = cudaSupport && rocmSupport;
    "CUDA is not targeting Linux" = cudaSupport && !stdenv.hostPlatform.isLinux;
    "Unsupported CUDA version" =
      cudaSupport
      && !(builtins.elem cudaPackages.cudaMajorVersion [
        "11"
        "12"
        "13"
      ]);
    "MPI cudatoolkit does not match cudaPackages.cudatoolkit" =
      MPISupport && cudaSupport && (mpi.cudatoolkit != cudaPackages.cudatoolkit);
    # This used to be a deep package set comparison between cudaPackages and
    # effectiveMagma.cudaPackages, making torch too strict in cudaPackages.
    # In particular, this triggered warnings from cuda's `aliases.nix`
    "Magma cudaPackages does not match cudaPackages" =
      cudaSupport
      && (effectiveMagma.cudaPackages.cudaMajorMinorVersion != cudaPackages.cudaMajorMinorVersion);
    "Triton cudaPackages does not match cudaPackages" =
      cudaSupport
      && (_tritonEffective.cudaPackages.cudaMajorMinorVersion != cudaPackages.cudaMajorMinorVersion);
  };

  unroll-src = writeShellScript "unroll-src" ''
    echo "{
      version,
      fetchFromGitLab,
      fetchFromGitHub,
      runCommand,
    }:
    assert version == "'"'$1'"'";"
    ${lib.getExe git-unroll} https://github.com/pytorch/pytorch v$1
    echo
    echo "# Update using: unroll-src [version]"
  '';

  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;
in
let
  # From here on, `stdenv` shall be `stdenv'`.
  stdenv = stdenv';
in
buildPythonPackage.override { inherit stdenv; } (finalAttrs: {
  pname = "torch";
  # Don't forget to update torch-bin to the same version.
  version = "2.13.0";
  pyproject = true;
  __structuredAttrs = true;

  outputs = [
    "out" # output standard python package
    "dev" # output libtorch headers
    "lib" # output libtorch libraries
    "cxxdev" # propagated deps for the cmake consumers of torch
  ];

  src = callPackage ./src.nix {
    inherit
      fetchFromGitHub
      fetchFromGitLab
      runCommand
      ;
    inherit (finalAttrs)
      version
      ;
  };

  patches = [
    ./clang19-template-warning.patch
    ./cmake-args.patch
    ./python-extension-suffix.patch
    ./cpp-extension-dependency-paths.patch
    ./wheel-tensorpipe-metadata.patch
    ./nnpack-psimd-array-contracts.patch
    # Unmerged upstream fix, followed by the remaining reduction repairs below.
    # https://github.com/pytorch/pytorch/pull/196216
    ./sparse-csr-empty-values.patch
    # Resolve reduction dtype before dispatch and keep wider accumulators
    # separate from explicit result dtypes on both CPU and CUDA.
    ./sparse-csr-reduction-dtypes.patch
  ]
  ++ lib.optionals (!(lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform)) [
    ./cross-blas-dot.patch
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    # Link What You Use runs ldd on the linked HOST libraries.
    ./disable-cross-lwyu.patch
  ]
  ++ lib.optionals (cudaSupport || rocmSupport) [
    ./symmetric-memory-socket-path.patch
  ]
  ++ lib.optionals cudaSupport [
    ./fix-cmake-cuda-toolkit.patch
    ./find-cuda-use-package-paths.patch
    ./cuda-launch-bounds.patch
    ./async-mm-eligibility.patch
    ./cudnn-version-display.patch

    # Let CMake find CUPTI through the variables we export in `preConfigure`, so that the
    # `CUDA::cupti` target kineto requires gets defined
    ./forward-cupti-env-vars.patch

    ./nvtx3-hpp-path-fix.patch

    # Don't emit both `sm_103` and `sm_103f` gencode flags, which nvcc rejects:
    # https://github.com/pytorch/pytorch/pull/187006
    (fetchpatch {
      name = "avoid-duplicate-sm_103-codegen.patch";
      url = "https://github.com/pytorch/pytorch/commit/94079bfd49e1d8a458a8d7714a8bf7379bba947a.patch";
      hash = "sha256-PFj8RihqeKTAogoCt59ikTbQ8wwpPJvUXGFlpBs8gE0=";
    })
  ]
  ++ lib.optionals (lib.getName blas.provider == "mkl") [
    # The CMake install tries to add some hardcoded rpaths, incompatible
    # with the Nix store, which fails. Simply remove this step to get
    # rpaths that point to the Nix store.
    ./disable-cmake-mkl-rpath.patch
  ]
  ++ lib.optionals rocmSupport [
    # [ROCm] Make AOTriton bundling optional via BUILD_AOTRITON_INTO_WHEEL flag
    # https://github.com/pytorch/pytorch/pull/182030
    ./no-bundle-aotriton.patch
  ];

  postPatch = ''
    cp ${../tests/csr-reductions.py} test/csr_reductions.py
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=77.0.0,<82" "setuptools"
  ''
  # Publish the same CUDA public interface to installed Python JIT consumers.
  # pkg-config supplies cudart's transitive CRT/CCCL headers without copying
  # stdenv propagation logic into the installed helper.
  + ''
    cudartCflags=""
    ${lib.optionalString cudaSupport ''
      cudartCflags="$($PKG_CONFIG --cflags-only-I cudart-${cudaPackages.cudaMajorMinorVersion})"
    ''}
    substituteInPlace torch/utils/cpp_extension.py \
      --subst-var-by cuda_cflags ${lib.escapeShellArg cudaIncludeFlags}" $cudartCflags" \
      --subst-var-by cuda_library_dirs ${lib.escapeShellArg cudaLibraryDirs}
  ''
  # Provide path to openssl binary for inductor code cache hash
  # InductorError: FileNotFoundError: [Errno 2] No such file or directory: 'openssl'
  + ''
    substituteInPlace torch/_inductor/codecache.py \
      --replace-fail '"openssl"' '"${lib.getExe openssl}"'
  ''
  + ''
    substituteInPlace cmake/public/cuda.cmake \
      --replace-fail \
        'message(FATAL_ERROR "Found two conflicting CUDA' \
        'message(WARNING "Found two conflicting CUDA' \
      --replace-warn \
        "set(CUDAToolkit_ROOT" \
        "# Upstream: set(CUDAToolkit_ROOT"
    substituteInPlace third_party/gloo/cmake/Cuda.cmake \
      --replace-warn "find_package(CUDAToolkit 7.0" "find_package(CUDAToolkit"
  ''
  # annotations (3.7), print_function (3.0), with_statement (2.6) are all supported
  + ''
    sed -i -e "/from __future__ import/d" **.py
    substituteInPlace third_party/NNPACK/CMakeLists.txt \
      --replace-fail "PYTHONPATH=" 'PYTHONPATH=$ENV{PYTHONPATH}:'
  ''
  # Ensure that torch profiler unwind uses addr2line from nix
  + ''
    substituteInPlace torch/csrc/profiler/unwind/unwind.cpp \
      --replace-fail 'addr2line_binary_ = "addr2line"' 'addr2line_binary_ = "${lib.getExe' binutils "addr2line"}"'
  ''
  # Ensures torch compile can find and use compilers from nix.
  + ''
    substituteInPlace torch/_inductor/config.py \
      --replace-fail '"clang++" if sys.platform == "darwin" else "g++"' \
      '"${lib.getExe' runtimeCC "${runtimeCC.targetPrefix}c++"}"'
  ''
  # ATen's generated config otherwise embeds the temporary wheel install
  # prefix. Its public headers are copied to dev on every backend/platform.
  + ''
    substituteInPlace aten/src/ATen/ATenConfig.cmake.in \
      --replace-fail '@ATEN_INCLUDE_DIR@' "$dev/include"
  ''
  # Doesn't pick up the environment variable?
  + lib.optionalString rocmSupport ''
    substituteInPlace third_party/kineto/libkineto/CMakeLists.txt \
      --replace-fail "\''$ENV{ROCM_SOURCE_DIR}" "${rocmtoolkit_joined}"
    patchShebangs aten/src/ATen/native/transformers/hip/flash_attn/ck/add_make_kernel_pt.sh
  ''
  # When possible, composable kernel as dependency, rather than built-in third-party
  + lib.optionalString (rocmSupport && !vendorComposableKernel) ''
    substituteInPlace aten/src/ATen/CMakeLists.txt \
      --replace-fail "list(APPEND ATen_HIP_INCLUDE \''${CMAKE_CURRENT_SOURCE_DIR}/../../../third_party/composable_kernel/include)" "" \
      --replace-fail "list(APPEND ATen_HIP_INCLUDE \''${CMAKE_CURRENT_SOURCE_DIR}/../../../third_party/composable_kernel/library/include)" ""
  ''
  # Remove PyTorch's FindCUDAToolkit.cmake and use CMake's default.
  # NOTE: Parts of pytorch rely on unmaintained FindCUDA.cmake with custom patches to support e.g.
  # newer architectures (sm_90a). We do want to delete vendored patches, but have to keep them
  # until https://github.com/pytorch/pytorch/issues/76082 is addressed
  + lib.optionalString cudaSupport ''
    rm cmake/Modules/FindCUDAToolkit.cmake
  ''
  # Otherwise, torch compile will fail at runtime if openmp is not available
  #   torch._inductor.exc.InductorError: CppCompileError: C++ compile error
  #   fatal error: 'omp.h' file not found
  + lib.optionalString stdenv.cc.isClang ''
    substituteInPlace torch/csrc/inductor/cpp_prefix.h \
      --replace-fail \
        "#include <omp.h>" \
        '#include "${lib.getInclude llvmPackages.openmp}/include/omp.h"'
  '';

  # NOTE(@connorbaker): Though we do not disable Gloo or MPI when building with CUDA support, caution should be taken
  # when using the different backends. Gloo's GPU support isn't great, and MPI and CUDA can't be used at the same time
  # without extreme care to ensure they don't lock each other out of shared resources.
  # For more, see https://github.com/open-mpi/ompi/issues/7733#issuecomment-629806195.
  preConfigure =
    lib.optionalString cudaSupport ''
      export TORCH_CUDA_ARCH_LIST="${gpuTargetString}"
      export CUDAToolkit_CUPTI_INCLUDE_DIR=${lib.getInclude cudaPackages.cuda_cupti}/include
      export CUDA_cupti_LIBRARY=${lib.getLib cudaPackages.cuda_cupti}/lib/libcupti.so
    ''
    + lib.optionalString (cudaSupport && cudaPackages ? cudnn) ''
      export CUDNN_INCLUDE_DIR=${lib.getInclude cudnn}/include
      export CUDNN_LIB_DIR=${lib.getLib cudnn}/lib
    ''
    + lib.optionalString rocmSupport ''
      export ROCM_PATH=${rocmtoolkit_joined}
      export ROCM_SOURCE_DIR=${rocmtoolkit_joined}
      export PYTORCH_ROCM_ARCH="${gpuTargetString}"
      export CMAKE_CXX_FLAGS="-I${rocmtoolkit_joined}/include"
      python tools/amd_build/build_amd.py
    '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

  # causes possible redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  env = {
    BUILD_NAMEDTENSOR = setBool true;
    BUILD_DOCS = setBool buildDocs;

    # We only do an imports check, so do not build tests either.
    BUILD_TEST = setBool false;

    # ninja hook doesn't automatically turn on ninja
    # because pytorch setup.py is responsible for this
    CMAKE_GENERATOR = "Ninja";

    # Unlike MKL, oneDNN (née MKLDNN) is FOSS, so we enable support for
    # it by default. PyTorch currently uses its own vendored version
    # of oneDNN through Intel iDeep.
    USE_MKLDNN = setBool mklDnnSupport;
    USE_MKLDNN_CBLAS = setBool mklDnnSupport;

    # Avoid using pybind11 from git submodule
    # Also avoids pytorch exporting the headers of pybind11
    USE_SYSTEM_PYBIND11 = true;

    # Multicore CPU convnet support
    USE_NNPACK = 1;

    # Explicitly enable MPS for Darwin
    USE_MPS = setBool stdenv.hostPlatform.isDarwin;

    # building torch.distributed on Darwin is disabled by default
    # https://pytorch.org/docs/stable/distributed.html#torch.distributed.is_available
    USE_DISTRIBUTED = setBool true;

    # Override the (weirdly) wrong version set by default. See
    # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
    # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
    PYTORCH_BUILD_VERSION = finalAttrs.version;
    PYTORCH_BUILD_NUMBER = 0;

    # In-tree builds of NCCL are not supported.
    # Use NCCL when cudaSupport is enabled and nccl is available.
    USE_NCCL = setBool useSystemNccl;
    USE_SYSTEM_NCCL = finalAttrs.env.USE_NCCL;
    USE_STATIC_NCCL = finalAttrs.env.USE_NCCL;

    USE_NVSHMEM = setBool withNvshmem;

    # Set the correct Python library path, broken since
    # https://github.com/pytorch/pytorch/commit/3d617333e
    PYTHON_LIB_REL_PATH = "${placeholder "out"}/${python.sitePackages}";
    # disable warnings as errors as they break the build on every compiler
    # bump, among other things.
    # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
    # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
    NIX_CFLAGS_COMPILE = toString (
      [
        "-Wno-error"
      ]
      # fix build aarch64-linux build failure with GCC14
      ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
        "-Wno-error=incompatible-pointer-types"
      ]
    );
    USE_VULKAN = setBool vulkanSupport;
  }
  // lib.optionalAttrs vulkanSupport {
    VULKAN_SDK = shaderc.bin;
  }
  // lib.optionalAttrs rocmSupport {
    AOTRITON_INSTALLED_PREFIX = "${rocmPackages.aotriton}";
    # Don't copy AOTriton to output, load from AOTriton package
    BUILD_AOTRITON_INTO_WHEEL = false;
    # Broken HIP flag setup, fails to compile due to not finding rocthrust
    # Only supports gfx942 so let's turn it off for now
    USE_FBGEMM_GENAI = setBool false;
  };

  cmakeFlags = [
    (lib.cmakeFeature "PYTHON_SIX_SOURCE_DIR" "${six.src}")
    (lib.cmakeFeature "Python_INCLUDE_DIR" "${lib.getInclude python}/include/${python.libPrefix}")
    (lib.cmakeFeature "Python_NumPy_INCLUDE_DIR" numpy.coreIncludeDir)
    # (lib.cmakeBool "CMAKE_FIND_DEBUG_MODE" true)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CUDAToolkit_VERSION" cudaPackages.cudaMajorMinorVersion)
    # Unbreaks version discovery in enable_language(CUDA) when wrapping nvcc with ccache
    # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/26363
    (lib.cmakeFeature "CMAKE_CUDA_COMPILER_TOOLKIT_VERSION" cudaPackages.cudaMajorMinorVersion)
  ]
  ++ lib.optionals (!(lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform)) (
    let
      nativeTools = buildPackages.callPackage ./native-tools.nix { inherit (finalAttrs) src; };
    in
    [
      (lib.cmakeFeature "NATIVE_BUILD_DIR" "${nativeTools.sleef}")
      (lib.cmakeFeature "CAFFE2_CUSTOM_PROTOC_EXECUTABLE" "${nativeTools.protoc}/bin/protoc")
    ]
  );

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    # Pass flags before either configure path, keeping caller overrides last.
    local torchCmakeFlags=()
    concatTo torchCmakeFlags cmakeFlags cmakeFlagsArray
    export CMAKE_ARGS="$(
      ${python.pythonOnBuildForHost.interpreter} -c \
        'import shlex, sys; print(shlex.join(sys.argv[1:]))' \
        "''${torchCmakeFlags[@]}"
    )''${CMAKE_ARGS:+ $CMAKE_ARGS}"
    # setup.py caches the build type at import time. Populate CMakeCache
    # before the wheel process imports it, including for multi-config builds.
    ${python.pythonOnBuildForHost.interpreter} setup.py build --cmake-only
  '';

  preFixup = ''
    function join_by { local IFS="$1"; shift; echo "$*"; }
    function strip2 {
      IFS=':'
      read -ra RP <<< $(patchelf --print-rpath $1)
      IFS=' '
      RP_NEW=$(join_by : ''${RP[@]:2})
      patchelf --set-rpath \$ORIGIN:''${RP_NEW} "$1"
    }
    for f in $(find ''${out} -name 'libcaffe2*.so')
    do
      strip2 $f
    done
  '';

  build-system = [
    cmake
    ninja
    numpy
    packaging
    pyyaml
    requests
    setuptools
    six
    typing-extensions
  ];

  nativeBuildInputs = [
    which
    pybind11
    pkg-config
    removeReferencesTo
  ]
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      autoAddDriverRunpath
      cuda_nvcc
    ]
  )
  ++ lib.optionals isCudaJetson [ cudaPackages.autoAddCudaCompatRunpath ]
  ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  buildInputs = [
    blas
    blas.provider
  ]
  # Including openmp leads to two copies being used on ARM, which segfaults.
  # https://github.com/pytorch/pytorch/issues/149201#issuecomment-2776842320
  ++ lib.optionals (stdenv.cc.isClang && !stdenv.hostPlatform.isAarch64) [ llvmPackages.openmp ]
  ++ cudaInputs
  ++ lib.optionals rocmSupport [ rocmPackages.llvm.openmp ]
  ++ lib.optionals (cudaSupport || rocmSupport) [ effectiveMagma ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ numactl ]
  ++ lib.optionals tritonSupport [ _tritonEffective ]
  ++ lib.optionals MPISupport [ mpi ]
  ++ lib.optionals rocmSupport [
    rocmtoolkit_joined
    rocmPackages.clr # Added separately so setup hook applies
  ];

  dependencies = [
    filelock
    fsspec
    jinja2
    networkx
    setuptools
    sympy
    typing-extensions

    # torch/csrc requires `pybind11` at runtime
    pybind11
  ]
  ++ lib.optionals withTensorboard [
    pillow
    protobuf
    six
    tensorboard
  ]
  ++ lib.optionals tritonSupport [ _tritonEffective ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ];

  # Custom output lists need the same role-before-output projection as
  # mkDerivation's propagatedBuildInputs/propagatedNativeBuildInputs.
  propagatedCxxBuildInputs = map (p: lib.getDev (p.__spliced.hostTarget or p)) (
    cudaInputs ++ lib.optionals MPISupport [ mpi ] ++ lib.optionals rocmSupport [ rocmtoolkit_joined ]
  );
  propagatedCxxNativeBuildInputs = lib.optionals cudaSupport [
    (lib.getDev (cudaPackages.cuda_nvcc.__spliced.buildHost or cudaPackages.cuda_nvcc))
  ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;

  pythonImportsCheck = [ "torch" ];

  nativeCheckInputs = [
    hypothesis
    ninja
    psutil
  ];

  checkPhase =
    with lib.versions;
    with lib.strings;
    concatStringsSep " " [
      "runHook preCheck"
      "${python.interpreter} test/run_test.py"
      "--exclude"
      (concatStringsSep " " [
        "utils" # utils requires git, which is not allowed in the check phase

        # "dataloader" # psutils correctly finds and triggers multiprocessing, but is too sandboxed to run -- resulting in numerous errors
        # ^^^^^^^^^^^^ NOTE: while test_dataloader does return errors, these are acceptable errors and do not interfere with the build

        # tensorboard has acceptable failures for pytorch 1.3.x due to dependencies on tensorboard-plugins
        (optionalString (majorMinor finalAttrs.version == "1.3") "tensorboard")
      ])
      "runHook postCheck"
    ];

  pythonRemoveDeps = [
    # In our dist-info the name is just "triton"
    "pytorch-triton-rocm"
  ];

  postInstall = ''
    find "$out/${python.sitePackages}/torch/include" "$out/${python.sitePackages}/torch/lib" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +

    mkdir $dev

    # CppExtension requires that include files are packaged with the main
    # python library output; which is why they are copied here.
    cp -r $out/${python.sitePackages}/torch/include $dev/include

    # Cmake files under /share are different and can be safely moved. This
    # avoids unnecessary closure blow-up due to apple sdk references when
    # USE_DISTRIBUTED is enabled.
    mv $out/${python.sitePackages}/torch/share $dev/share

    # Fix up library paths for split outputs
    substituteInPlace \
      $dev/share/cmake/Torch/TorchConfig.cmake \
      --replace-fail \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

    substituteInPlace \
      $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
      --replace-fail \''${_IMPORT_PREFIX}/lib "$lib/lib"

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';

  postFixup = ''
    mkdir -p "$cxxdev/nix-support"
    printWords "''${!outputDev}" "''${propagatedCxxBuildInputs[@]}" > "$cxxdev/nix-support/propagated-build-inputs"
    printWords "''${propagatedCxxNativeBuildInputs[@]}" > "$cxxdev/nix-support/propagated-native-build-inputs"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    for f in $(ls $lib/lib/*.dylib); do
        install_name_tool -id $lib/lib/$(basename $f) $f || true
    done

    install_name_tool -change @rpath/libshm.dylib $lib/lib/libshm.dylib $lib/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libtorch_python.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libtorch_python.dylib

    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libtorch.dylib

    install_name_tool -change @rpath/libtorch.dylib $lib/lib/libtorch.dylib $lib/lib/libshm.dylib
    install_name_tool -change @rpath/libc10.dylib $lib/lib/libc10.dylib $lib/lib/libshm.dylib
  '';

  # See https://github.com/NixOS/nixpkgs/issues/296179
  #
  # This is a quick hack to add `libnvrtc` to the runpath so that torch can find
  # it when it is needed at runtime.
  extraRunpaths = lib.optionals cudaSupport [ "${lib.getLib cudaPackages.cuda_nvrtc}/lib" ];
  postPhases = lib.optionals stdenv.hostPlatform.isLinux [ "postPatchelfPhase" ];
  postPatchelfPhase = ''
    while IFS= read -r -d $'\0' elf ; do
      for extra in $extraRunpaths ; do
        echo patchelf "$elf" --add-rpath "$extra" >&2
        patchelf "$elf" --add-rpath "$extra"
      done
    done < <(
      find "''${!outputLib}" "$out" -type f -iname '*.so' -print0
    )
  '';

  # Builds in 2+h with 2 cores, and ~15m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit
      cudaSupport
      cudaPackages
      rocmSupport
      rocmPackages
      unroll-src
      gpuTargetString
      rocmtoolkit_joined
      ;
    cudaCapabilities = if cudaSupport then flags.cudaCapabilities else [ ];
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
    triton = _tritonEffective;
    # To help debug when a package is broken due to CUDA support
    inherit brokenConditions;
    tests =
      let
        csrTester =
          feature:
          (cudaPackages.writeGpuTestPython.override { python3Packages = python.pkgs; }) {
            name = "torch-csr-reductions" + lib.optionalString (feature == null) "-cpu";
            inherit feature;
            libraries = [ finalAttrs.finalPackage ];
            makeWrapperArgs = lib.optionals (feature == null) [
              "--add-flags"
              "--device cpu"
            ];
          } (builtins.readFile ../tests/csr-reductions.py);
      in
      callPackage ../tests {
        inherit rocmSupport cudaSupport;
      }
      // {
        nnpackPSIMD = buildPackages.callPackage ../tests/nnpack-psimd.nix {
          inherit (finalAttrs) src;
          nnpackPatch = ./nnpack-psimd-array-contracts.patch;
        };
        tester-csrReductionsCpu = csrTester null;
      }
      // lib.optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
        csrReductionsCpu = (csrTester null).gpuCheck;
      }
      // lib.optionalAttrs (cudaSupport && cudaPackages.cudaAtLeast "12.9") {
        cudaArchitectures = callPackage ../tests/cuda-architectures.nix {
          inherit cudaPackages;
          inherit (finalAttrs) src;
        };
      }
      // lib.optionalAttrs cudaSupport {
        tester-cppExtension = callPackage ../tests/cpp-extension.nix {
          inherit cudaPackages python;
          torch = finalAttrs.finalPackage;
        };
        tester-csrReductions = csrTester "cuda";
      }
      // lib.optionalAttrs (cudaSupport && stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
        symmetricMemorySocketName = callPackage ../tests/symm-mem-socket-name.nix {
          inherit (finalAttrs) src;
          torch = finalAttrs.finalPackage;
          socketPatch = ./symmetric-memory-socket-path.patch;
        };
      };
  };

  meta = {
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${finalAttrs.version}";
    # keep PyTorch in the description so the package can be found under that name on search.nixos.org
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      caniko
      GaetanLepage
      LunNova # esp. for ROCm
      teh
      thoughtpolice
      tscholak
    ]; # tscholak esp. for darwin-related builds
    platforms =
      lib.platforms.linux ++ lib.optionals (!cudaSupport && !rocmSupport) lib.platforms.darwin;
    broken = builtins.any trivial.id (builtins.attrValues brokenConditions);
  };
})
