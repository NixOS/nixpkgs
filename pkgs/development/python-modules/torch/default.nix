{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchFromGitea,
  buildPythonPackage,
  python,
  runCommand,
  writeShellScript,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  autoAddDriverRunpath,
  effectiveMagma ?
    if cudaSupport then
      magma-cuda-static
    else if rocmSupport then
      magma-hip
    else
      magma,
  magma,
  magma-hip,
  magma-cuda-static,
  # Use the system NCCL as long as we're targeting CUDA on a supported platform.
  useSystemNccl ? (cudaSupport && !cudaPackages.nccl.meta.unsupported || rocmSupport),
  MPISupport ? false,
  mpi,
  buildDocs ? false,

  # tests.cudaAvailable:
  callPackage,

  # Native build inputs
  cmake,
  symlinkJoin,
  which,
  pybind11,
  removeReferencesTo,

  # Build inputs
  apple-sdk_13,
  numactl,

  # dependencies
  astunparse,
  fsspec,
  filelock,
  jinja2,
  networkx,
  sympy,
  numpy,
  pyyaml,
  cffi,
  click,
  typing-extensions,
  # ROCm build and `torch.compile` requires `triton`
  tritonSupport ? (!stdenv.hostPlatform.isDarwin),
  triton,

  # TODO: 1. callPackage needs to learn to distinguish between the task
  #          of "asking for an attribute from the parent scope" and
  #          the task of "exposing a formal parameter in .override".
  # TODO: 2. We should probably abandon attributes such as `torchWithCuda` (etc.)
  #          as they routinely end up consuming the wrong arguments\
  #          (dependencies without cuda support).
  #          Instead we should rely on overlays and nixpkgsFun.
  # (@SomeoneSerge)
  _tritonEffective ? if cudaSupport then triton-cuda else triton,
  triton-cuda,

  # Unit tests
  hypothesis,
  psutil,

  # Disable MKLDNN on aarch64-darwin, it negatively impacts performance,
  # this is also what official pytorch build does
  mklDnnSupport ? !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64),

  # virtual pkg that consistently instantiates blas across nixpkgs
  # See https://github.com/NixOS/nixpkgs/pull/83888
  blas,

  # ninja (https://ninja-build.org) must be available to run C++ extensions tests,
  ninja,

  # dependencies for torch.utils.tensorboard
  pillow,
  six,
  future,
  tensorboard,
  protobuf,

  # ROCm dependencies
  rocmSupport ? config.rocmSupport,
  rocmPackages_5,
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
  inherit (cudaPackages) cudaFlags cudnn nccl;

  triton = throw "python3Packages.torch: use _tritonEffective instead of triton to avoid divergence";

  rocmPackages = rocmPackages_5;

  setBool = v: if v then "1" else "0";

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

  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = with rocmPackages; [
      rocm-core
      clr
      rccl
      miopen
      miopengemm
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
      hipsolver
      hipblas
      rocminfo
      rocm-thunk
      rocm-comgr
      rocm-device-libs
      rocm-runtime
      clr.icd
      hipify
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
      ]);
    "MPI cudatoolkit does not match cudaPackages.cudatoolkit" =
      MPISupport && cudaSupport && (mpi.cudatoolkit != cudaPackages.cudatoolkit);
    # This used to be a deep package set comparison between cudaPackages and
    # effectiveMagma.cudaPackages, making torch too strict in cudaPackages.
    # In particular, this triggered warnings from cuda's `aliases.nix`
    "Magma cudaPackages does not match cudaPackages" =
      cudaSupport && (effectiveMagma.cudaPackages.cudaVersion != cudaPackages.cudaVersion);
    "Rocm support is currently broken because `rocmPackages.hipblaslt` is unpackaged. (2024-06-09)" =
      rocmSupport;
  };

  git-unroll = fetchFromGitea {
    domain = "codeberg.org";
    owner = "gm6k";
    repo = "git-unroll";
    rev = "96bf24f2af153310ec59979c123a8cefda8636db";
    hash = "sha256-BTlq2Pm4l/oypBzKKpxExVPyQ0CcAP8llUnl/fd3DUU=";
  };

  unroll-src = writeShellScript "unroll-src" ''
    echo "{
      version,
      fetchFromGitLab,
      fetchFromGitHub,
      runCommand,
    }:
    assert version == "'"'$1'"'";"
    ${git-unroll}/unroll https://github.com/pytorch/pytorch v$1
    echo
    echo "# Update using: unroll-src [version]"
  '';
in
buildPythonPackage rec {
  pname = "torch";
  # Don't forget to update torch-bin to the same version.
  version = "2.5.1";
  pyproject = true;

  outputs = [
    "out" # output standard python package
    "dev" # output libtorch headers
    "lib" # output libtorch libraries
    "cxxdev" # propagated deps for the cmake consumers of torch
  ];
  cudaPropagateToOutput = "cxxdev";

  src = callPackage ./src.nix {
    inherit
      version
      fetchFromGitHub
      fetchFromGitLab
      runCommand
      ;
  };

  patches =
    lib.optionals cudaSupport [ ./fix-cmake-cuda-toolkit.patch ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
      # pthreadpool added support for Grand Central Dispatch in April
      # 2020. However, this relies on functionality (DISPATCH_APPLY_AUTO)
      # that is available starting with macOS 10.13. However, our current
      # base is 10.12. Until we upgrade, we can fall back on the older
      # pthread support.
      ./pthreadpool-disable-gcd.diff
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Propagate CUPTI to Kineto by overriding the search path with environment variables.
      # https://github.com/pytorch/pytorch/pull/108847
      ./pytorch-pr-108847.patch
    ]
    ++ lib.optionals (lib.getName blas.provider == "mkl") [
      # The CMake install tries to add some hardcoded rpaths, incompatible
      # with the Nix store, which fails. Simply remove this step to get
      # rpaths that point to the Nix store.
      ./disable-cmake-mkl-rpath.patch
    ];

  postPatch =
    ''
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
    + lib.optionalString rocmSupport ''
      # https://github.com/facebookincubator/gloo/pull/297
      substituteInPlace third_party/gloo/cmake/Hipify.cmake \
        --replace "\''${HIPIFY_COMMAND}" "python \''${HIPIFY_COMMAND}"

      # Replace hard-coded rocm paths
      substituteInPlace caffe2/CMakeLists.txt \
        --replace "/opt/rocm" "${rocmtoolkit_joined}" \
        --replace "hcc/include" "hip/include" \
        --replace "rocblas/include" "include/rocblas" \
        --replace "hipsparse/include" "include/hipsparse"

      # Doesn't pick up the environment variable?
      substituteInPlace third_party/kineto/libkineto/CMakeLists.txt \
        --replace "\''$ENV{ROCM_SOURCE_DIR}" "${rocmtoolkit_joined}" \
        --replace "/opt/rocm" "${rocmtoolkit_joined}"

      # Strangely, this is never set in cmake
      substituteInPlace cmake/public/LoadHIP.cmake \
        --replace "set(ROCM_PATH \$ENV{ROCM_PATH})" \
          "set(ROCM_PATH \$ENV{ROCM_PATH})''\nset(ROCM_VERSION ${lib.concatStrings (lib.intersperse "0" (lib.splitVersion rocmPackages.clr.version))})"
    ''
    # Detection of NCCL version doesn't work particularly well when using the static binary.
    + lib.optionalString cudaSupport ''
      substituteInPlace cmake/Modules/FindNCCL.cmake \
        --replace \
          'message(FATAL_ERROR "Found NCCL header version and library version' \
          'message(WARNING "Found NCCL header version and library version'
    ''
    # Remove PyTorch's FindCUDAToolkit.cmake and use CMake's default.
    # NOTE: Parts of pytorch rely on unmaintained FindCUDA.cmake with custom patches to support e.g.
    # newer architectures (sm_90a). We do want to delete vendored patches, but have to keep them
    # until https://github.com/pytorch/pytorch/issues/76082 is addressed
    + lib.optionalString cudaSupport ''
      rm cmake/Modules/FindCUDAToolkit.cmake
    ''
    # error: no member named 'aligned_alloc' in the global namespace; did you mean simply 'aligned_alloc'
    # This lib overrided aligned_alloc hence the error message. Tltr: his function is linkable but not in header.
    +
      lib.optionalString
        (stdenv.hostPlatform.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinSdkVersion "11.0")
        ''
          substituteInPlace third_party/pocketfft/pocketfft_hdronly.h --replace-fail '#if (__cplusplus >= 201703L) && (!defined(__MINGW32__)) && (!defined(_MSC_VER))
          inline void *aligned_alloc(size_t align, size_t size)' '#if 0
          inline void *aligned_alloc(size_t align, size_t size)'
        '';

  # NOTE(@connorbaker): Though we do not disable Gloo or MPI when building with CUDA support, caution should be taken
  # when using the different backends. Gloo's GPU support isn't great, and MPI and CUDA can't be used at the same time
  # without extreme care to ensure they don't lock each other out of shared resources.
  # For more, see https://github.com/open-mpi/ompi/issues/7733#issuecomment-629806195.
  preConfigure =
    lib.optionalString cudaSupport ''
      export TORCH_CUDA_ARCH_LIST="${gpuTargetString}"
      export CUPTI_INCLUDE_DIR=${lib.getDev cudaPackages.cuda_cupti}/include
      export CUPTI_LIBRARY_DIR=${lib.getLib cudaPackages.cuda_cupti}/lib
    ''
    + lib.optionalString (cudaSupport && cudaPackages ? cudnn) ''
      export CUDNN_INCLUDE_DIR=${lib.getLib cudnn}/include
      export CUDNN_LIB_DIR=${cudnn.lib}/lib
    ''
    + lib.optionalString rocmSupport ''
      export ROCM_PATH=${rocmtoolkit_joined}
      export ROCM_SOURCE_DIR=${rocmtoolkit_joined}
      export PYTORCH_ROCM_ARCH="${gpuTargetString}"
      export CMAKE_CXX_FLAGS="-I${rocmtoolkit_joined}/include -I${rocmtoolkit_joined}/include/rocblas"
      python tools/amd_build/build_amd.py
    '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

  # causes possible redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  BUILD_NAMEDTENSOR = setBool true;
  BUILD_DOCS = setBool buildDocs;

  # We only do an imports check, so do not build tests either.
  BUILD_TEST = setBool false;

  # Unlike MKL, oneDNN (née MKLDNN) is FOSS, so we enable support for
  # it by default. PyTorch currently uses its own vendored version
  # of oneDNN through Intel iDeep.
  USE_MKLDNN = setBool mklDnnSupport;
  USE_MKLDNN_CBLAS = setBool mklDnnSupport;

  # Avoid using pybind11 from git submodule
  # Also avoids pytorch exporting the headers of pybind11
  USE_SYSTEM_PYBIND11 = true;

  # NB technical debt: building without NNPACK as workaround for missing `six`
  USE_NNPACK = 0;

  # Explicitly enable MPS for Darwin
  USE_MPS = setBool stdenv.hostPlatform.isDarwin;

  cmakeFlags =
    [
      # (lib.cmakeBool "CMAKE_FIND_DEBUG_MODE" true)
      (lib.cmakeFeature "CUDAToolkit_VERSION" cudaPackages.cudaVersion)
    ]
    ++ lib.optionals cudaSupport [
      # Unbreaks version discovery in enable_language(CUDA) when wrapping nvcc with ccache
      # Cf. https://gitlab.kitware.com/cmake/cmake/-/issues/26363
      (lib.cmakeFeature "CMAKE_CUDA_COMPILER_TOOLKIT_VERSION" cudaPackages.cudaVersion)
    ];

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    ${python.pythonOnBuildForHost.interpreter} setup.py build --cmake-only
    ${cmake}/bin/cmake build
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

  # Override the (weirdly) wrong version set by default. See
  # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
  # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
  PYTORCH_BUILD_VERSION = version;
  PYTORCH_BUILD_NUMBER = 0;

  # In-tree builds of NCCL are not supported.
  # Use NCCL when cudaSupport is enabled and nccl is available.
  USE_NCCL = setBool useSystemNccl;
  USE_SYSTEM_NCCL = USE_NCCL;
  USE_STATIC_NCCL = USE_NCCL;

  # Set the correct Python library path, broken since
  # https://github.com/pytorch/pytorch/commit/3d617333e
  PYTHON_LIB_REL_PATH = "${placeholder "out"}/${python.sitePackages}";

  env =
    {
      # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
      # (upstream seems to have fixed this in the wrong place?)
      # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
      # https://github.com/pytorch/pytorch/issues/22346
      #
      # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
      # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
      NIX_CFLAGS_COMPILE = toString (
        (
          lib.optionals (blas.implementation == "mkl") [ "-Wno-error=array-bounds" ]
          # Suppress gcc regression: avx512 math function raises uninitialized variable warning
          # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105593
          # See also: Fails to compile with GCC 12.1.0 https://github.com/pytorch/pytorch/issues/77939
          ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "12.0.0") [
            "-Wno-error=maybe-uninitialized"
            "-Wno-error=uninitialized"
          ]
          # Since pytorch 2.0:
          # gcc-12.2.0/include/c++/12.2.0/bits/new_allocator.h:158:33: error: ‘void operator delete(void*, std::size_t)’
          # ... called on pointer ‘<unknown>’ with nonzero offset [1, 9223372036854775800] [-Werror=free-nonheap-object]
          ++ lib.optionals (stdenv.cc.isGNU && lib.versions.major stdenv.cc.version == "12") [
            "-Wno-error=free-nonheap-object"
          ]
          # .../source/torch/csrc/autograd/generated/python_functions_0.cpp:85:3:
          # error: cast from ... to ... converts to incompatible function type [-Werror,-Wcast-function-type-strict]
          ++ lib.optionals (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16") [
            "-Wno-error=cast-function-type-strict"
            # Suppresses the most spammy warnings.
            # This is mainly to fix https://github.com/NixOS/nixpkgs/issues/266895.
          ]
          ++ lib.optionals rocmSupport [
            "-Wno-#warnings"
            "-Wno-cpp"
            "-Wno-unknown-warning-option"
            "-Wno-ignored-attributes"
            "-Wno-deprecated-declarations"
            "-Wno-defaulted-function-deleted"
            "-Wno-pass-failed"
          ]
          ++ [
            "-Wno-unused-command-line-argument"
            "-Wno-uninitialized"
            "-Wno-array-bounds"
            "-Wno-free-nonheap-object"
            "-Wno-unused-result"
          ]
          ++ lib.optionals stdenv.cc.isGNU [
            "-Wno-maybe-uninitialized"
            "-Wno-stringop-overflow"
          ]
        )
      );

      USE_VULKAN = setBool vulkanSupport;
    }
    // lib.optionalAttrs vulkanSupport {
      VULKAN_SDK = shaderc.bin;
    };

  nativeBuildInputs =
    [
      cmake
      which
      ninja
      pybind11
      removeReferencesTo
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        autoAddDriverRunpath
        cuda_nvcc
      ]
    )
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  buildInputs =
    [
      blas
      blas.provider
    ]
    ++ lib.optionals cudaSupport (
      with cudaPackages;
      [
        cuda_cccl # <thrust/*>
        cuda_cudart # cuda_runtime.h and libraries
        cuda_cupti # For kineto
        cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildInputs, it's needed here too
        cuda_nvml_dev # <nvml.h>
        cuda_nvrtc
        cuda_nvtx # -llibNVToolsExt
        libcublas
        libcufft
        libcurand
        libcusolver
        libcusparse
      ]
      ++ lists.optionals (cudaPackages ? cudnn) [ cudnn ]
      ++ lists.optionals useSystemNccl [
        # Some platforms do not support NCCL (i.e., Jetson)
        nccl # Provides nccl.h AND a static copy of NCCL!
      ]
      ++ lists.optionals (strings.versionOlder cudaVersion "11.8") [
        cuda_nvprof # <cuda_profiler_api.h>
      ]
      ++ lists.optionals (strings.versionAtLeast cudaVersion "11.8") [
        cuda_profiler_api # <cuda_profiler_api.h>
      ]
    )
    ++ lib.optionals rocmSupport [ rocmPackages.llvm.openmp ]
    ++ lib.optionals (cudaSupport || rocmSupport) [ effectiveMagma ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ numactl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_13
    ]
    ++ lib.optionals tritonSupport [ _tritonEffective ]
    ++ lib.optionals MPISupport [ mpi ]
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  pythonRelaxDeps = [
    "sympy"
  ];
  dependencies =
    [
      astunparse
      cffi
      click
      numpy
      pyyaml

      # From install_requires:
      fsspec
      filelock
      typing-extensions
      sympy
      networkx
      jinja2

      # the following are required for tensorboard support
      pillow
      six
      future
      tensorboard
      protobuf

      # torch/csrc requires `pybind11` at runtime
      pybind11
    ]
    ++ lib.optionals tritonSupport [ _tritonEffective ]
    ++ lib.optionals vulkanSupport [
      vulkan-headers
      vulkan-loader
    ];

  propagatedCxxBuildInputs =
    [ ] ++ lib.optionals MPISupport [ mpi ] ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

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
        (optionalString (majorMinor version == "1.3") "tensorboard")
      ])
      "runHook postCheck"
    ];

  pythonRemoveDeps = [
    # In our dist-info the name is just "triton"
    "pytorch-triton-rocm"
  ];

  postInstall =
    ''
      find "$out/${python.sitePackages}/torch/include" "$out/${python.sitePackages}/torch/lib" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +

      mkdir $dev
      cp -r $out/${python.sitePackages}/torch/include $dev/include
      cp -r $out/${python.sitePackages}/torch/share $dev/share

      # Fix up library paths for split outputs
      substituteInPlace \
        $dev/share/cmake/Torch/TorchConfig.cmake \
        --replace \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

      substituteInPlace \
        $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
        --replace \''${_IMPORT_PREFIX}/lib "$lib/lib"

      mkdir $lib
      mv $out/${python.sitePackages}/torch/lib $lib/lib
      ln -s $lib/lib $out/${python.sitePackages}/torch/lib
    ''
    + lib.optionalString rocmSupport ''
      substituteInPlace $dev/share/cmake/Tensorpipe/TensorpipeTargets-release.cmake \
        --replace "\''${_IMPORT_PREFIX}/lib64" "$lib/lib"

      substituteInPlace $dev/share/cmake/ATen/ATenConfig.cmake \
        --replace "/build/source/torch/include" "$dev/include"
    '';

  postFixup =
    ''
      mkdir -p "$cxxdev/nix-support"
      printWords "''${propagatedCxxBuildInputs[@]}" >> "$cxxdev/nix-support/propagated-build-inputs"
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
      ;
    cudaCapabilities = if cudaSupport then supportedCudaCapabilities else [ ];
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
    # To help debug when a package is broken due to CUDA support
    inherit brokenConditions;
    tests = callPackage ./tests.nix { };
  };

  meta = {
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # keep PyTorch in the description so the package can be found under that name on search.nixos.org
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      teh
      thoughtpolice
      tscholak
    ]; # tscholak esp. for darwin-related builds
    platforms =
      lib.platforms.linux
      ++ lib.optionals (!cudaSupport && !rocmSupport) lib.platforms.darwin;
    broken = builtins.any trivial.id (builtins.attrValues brokenConditions);
  };
}
