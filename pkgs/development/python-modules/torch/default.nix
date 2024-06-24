{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  python,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  cudnn ? null,
  autoAddDriverRunpath,
  magma,
  # Use the system NCCL as long as we're targeting CUDA on a supported platform.
  useSystemNccl ? (cudaSupport && !cudaPackages.nccl.meta.unsupported || rocmSupport),
  MPISupport ? false,
  mpi,
  buildDocs ? false,

  # Native build inputs
  cmake,
  symlinkJoin,
  which,
  pybind11,
  removeReferencesTo,
  pythonRelaxDepsHook,

  # Build inputs
  numactl,
  Accelerate,
  CoreServices,
  libobjc,

  # Propagated build inputs
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
  # ROCm build and `torch.compile` requires `openai-triton`
  tritonSupport ? (!stdenv.isDarwin),
  openai-triton,

  # Unit tests
  hypothesis,
  psutil,

  # Disable MKLDNN on aarch64-darwin, it negatively impacts performance,
  # this is also what official pytorch build does
  mklDnnSupport ? !(stdenv.isDarwin && stdenv.isAarch64),

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

  pythonOlder,

  # ROCm dependencies
  rocmSupport ? config.rocmSupport,
  rocmPackages,
  gpuTargets ? [ ],
}:

let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.lists)
    concatMap
    intersectLists
    map
    optionals
    subtractLists
    ;
  inherit (lib.meta) getExe';
  inherit (lib.strings)
    concatStringsSep
    optionalString
    replaceChars
    versionAtLeast
    versionOlder
    ;
  inherit (lib.trivial) id throwIf;
  inherit (lib.versions) major majorMinor;

  inherit (stdenv)
    cc
    isDarwin
    isLinux
    isx86_64
    ;
  inherit (stdenv.hostPlatform) darwinSdkVersion;

  inherit (cudaPackages)
    cuda_cccl
    cuda_cudart
    cuda_cupti
    cuda_nvcc
    cuda_nvml_dev
    cuda_nvprof
    cuda_nvrtc
    cuda_nvtx
    cuda_profiler_api
    cudaAtLeast
    cudaFlags
    cudaMajorMinorVersion
    cudaOlder
    libcublas
    libcufft
    libcurand
    libcusolver
    libcusparse
    nccl
    ;

  cudaBuildInputs =
    let
      # NOTE: Reminder that due to the way cudaPackages are created, lib.getOutput and friends don't work.
      # As such, we need to create our own functions to get the dev and lib outputs.
      getDevAndLib = pkg: [
        pkg.dev
        pkg.lib
      ];
      getDev = pkg: pkg.dev;
    in
    # Need full output for cuda_runtime.h, libcuda.so, and libcuda.a
    [ cuda_cudart ]
    # Packages we need both dev and lib from
    ++ concatMap getDevAndLib (
      [
        cuda_cupti # For kineto
        cuda_nvrtc
        cuda_nvtx # -llibNVToolsExt
        libcublas
        libcufft
        libcurand
        libcusolver
        libcusparse
      ]
      ++ optionals (cudnn != null) [ cudnn ]
    )
    # Packages we only need dev from
    ++ map getDev (
      [
        cuda_cccl # <thrust/*>
        cuda_nvcc # crt/host_config.h; even though we include this in nativeBuildinputs, it's needed here too
        cuda_nvml_dev # <nvml.h>
      ]
      # nccl.dev output provides nccl.h AND a static copy of NCCL!
      ++ optionals useSystemNccl [ nccl ]
      # Prior to CUDA 11.8, cuda_nvprof provides <cuda_profiler_api.h>
      ++ optionals (cudaOlder "11.8") [ cuda_nvprof ]
      # After CUDA 11.8, cuda_profiler_api provides <cuda_profiler_api.h>
      ++ optionals (cudaAtLeast "11.8") [ cuda_profiler_api ]
    );

  setBool = v: if v then "1" else "0";

  # https://github.com/pytorch/pytorch/blob/v2.3.1/torch/utils/cpp_extension.py#L1955-L1956
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
      ptx = map (x: "${x}+PTX") real;
    in
    real ++ optionals cudaFlags.enableForwardCompat ptx;

  # NOTE: The lists.subtractLists function is perhaps a bit unintuitive. It subtracts the elements
  #   of the first list *from* the second list. That means:
  #   lists.subtractLists a b = b - a

  # For CUDA
  supportedCudaCapabilities = intersectLists cudaFlags.cudaCapabilities supportedTorchCudaCapabilities;
  unsupportedCudaCapabilities = subtractLists supportedCudaCapabilities cudaFlags.cudaCapabilities;

  # Use trivial.warnIf to print a warning if any unsupported GPU targets are specified.
  gpuArchWarner =
    supported: unsupported:
    throwIf (supported == [ ]) (
      "No supported GPU targets specified. Requested GPU targets: " + concatStringsSep ", " unsupported
    ) supported;

  # Create the gpuTargetString.
  gpuTargetString = concatStringsSep ";" (
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

  brokenConditions =
    # All of these predicates have a `cudaSupport &&` prefix, so we factor it out.
    optionalAttrs cudaSupport (
      let
        cudnnMajorMinorVersion = majorMinor cudnn.version;
        isCuda11_8 = cudaMajorMinorVersion == "11.8";
        isCuda12_1 = cudaMajorMinorVersion == "12.1";
        isCudnn8_7 = cudnnMajorMinorVersion == "8.7";
        isCudnn8_9 = cudnnMajorMinorVersion == "8.9";
      in
      {
        "CUDA and ROCm are mutually exclusive" = rocmSupport;
        "CUDA is not targeting Linux" = !isLinux;

        # NOTE: Make sure to update python-packages.nix when updating Torch to a new version!
        "Unsupported CUDA version" = !(isCuda11_8 || isCuda12_1);
        "Unsupported CUDNN version" =
          (cudnn != null) && !((isCudnn8_7 && isCuda11_8) || (isCudnn8_9 && isCuda12_1));
      }
    )
    # All of these predicates have a `rocmSupport &&` prefix, so we factor it out.
    // optionalAttrs rocmSupport {
      "Rocm support is currently broken because `rocmPackages.hipblaslt` is unpackaged. (2024-06-09)" =
        true;
    };
in
buildPythonPackage rec {
  pname = "torch";
  # Don't forget to update torch-bin to the same version.
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8.0";

  outputs = [
    "out" # output standard python package
    "dev" # output libtorch headers
    "lib" # output libtorch libraries
    "cxxdev" # propagated deps for the cmake consumers of torch
  ];
  cudaPropagateToOutput = "cxxdev";

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "pytorch";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-vpgtOqzIDKgRuqdT8lB/g6j+oMIH1RPxdbjtlzZFjV8=";
  };

  patches =
    optionals cudaSupport [
      ./fix-cmake-cuda-toolkit.patch
      # TODO: Revisit this patch after the release following 2.3.1.
      (fetchpatch {
        name = "fix-cmake-regex-to-match-newly-introduced-9.0a-architecture.patch";
        url = "https://github.com/pytorch/pytorch/pull/123243/commits/fb8cd2dbf4816b697580dfa888d0484c1c1c8df7.patch";
        hash = "sha256-7TZkYFV7g1bU/VcmNADAK9Rd5rWsAevc6cxYPvmF5ds=";
      })
      # TODO: Revisit this patch after the release following 2.3.1.
      (fetchpatch {
        name = "allow-building-for-sm90a.patch";
        url = "https://github.com/pytorch/pytorch/pull/125523/commits/451ad6129aedd90afdbe6885d497ab13ec359730.patch";
        hash = "sha256-ePhWJlA49zdkTrpL/QDdecH82O9VXpaAXDciaaP4rf0=";
      })
    ]
    ++ optionals (isDarwin && isx86_64) [
      # pthreadpool added support for Grand Central Dispatch in April
      # 2020. However, this relies on functionality (DISPATCH_APPLY_AUTO)
      # that is available starting with macOS 10.13. However, our current
      # base is 10.12. Until we upgrade, we can fall back on the older
      # pthread support.
      ./pthreadpool-disable-gcd.diff
    ]
    ++ optionals isLinux [
      # Propagate CUPTI to Kineto by overriding the search path with environment variables.
      # https://github.com/pytorch/pytorch/pull/108847
      ./pytorch-pr-108847.patch
    ];

  postPatch =
    optionalString rocmSupport ''
      # https://github.com/facebookincubator/gloo/pull/297
      substituteInPlace third_party/gloo/cmake/Hipify.cmake \
        --replace-fail "\''${HIPIFY_COMMAND}" "python \''${HIPIFY_COMMAND}"

      # Replace hard-coded rocm paths
      substituteInPlace caffe2/CMakeLists.txt \
        --replace-fail "/opt/rocm" "${rocmtoolkit_joined}" \
        --replace-fail "hcc/include" "hip/include" \
        --replace-fail "rocblas/include" "include/rocblas" \
        --replace-fail "hipsparse/include" "include/hipsparse"

      # Doesn't pick up the environment variable?
      substituteInPlace third_party/kineto/libkineto/CMakeLists.txt \
        --replace-fail "\''$ENV{ROCM_SOURCE_DIR}" "${rocmtoolkit_joined}" \
        --replace-fail "/opt/rocm" "${rocmtoolkit_joined}"

      # Strangely, this is never set in cmake
      substituteInPlace cmake/public/LoadHIP.cmake \
        --replace-fail "set(ROCM_PATH \$ENV{ROCM_PATH})" \
          "set(ROCM_PATH \$ENV{ROCM_PATH})''\nset(ROCM_VERSION ${
            replaceChars [ "." ] [ "0" ] rocmPackages.clr.version
          })"
    ''
    # Detection of NCCL version doesn't work particularly well when using the static binary.
    + optionalString cudaSupport ''
      substituteInPlace cmake/Modules/FindNCCL.cmake \
        --replace-fail \
          'message(FATAL_ERROR "Found NCCL header version and library version' \
          'message(WARNING "Found NCCL header version and library version'
    ''
    # Remove PyTorch's FindCUDAToolkit.cmake and use CMake's default.
    # NOTE: We do not remove cmake/Modules_CUDA_fix/upstream because PyTorch has patched CMakes FindCUDA.cmake to
    #   allow building with newer architectures (like sm_90a) and we want to keep that.
    + optionalString cudaSupport ''
      rm cmake/Modules/FindCUDAToolkit.cmake
    ''
    # error: no member named 'aligned_alloc' in the global namespace; did you mean simply 'aligned_alloc'
    # This lib overrided aligned_alloc hence the error message. Tltr: his function is linkable but not in header.
    + optionalString (isDarwin && versionOlder darwinSdkVersion "11.0") ''
      substituteInPlace third_party/pocketfft/pocketfft_hdronly.h --replace-fail \
      '#if (__cplusplus >= 201703L) && (!defined(__MINGW32__)) && (!defined(_MSC_VER))
      inline void *aligned_alloc(size_t align, size_t size)' \
      '#if 0
      inline void *aligned_alloc(size_t align, size_t size)'
    '';

  preConfigure = optionalString rocmSupport ''
    python tools/amd_build/build_amd.py
  '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

  # causes possible redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    ${python.pythonOnBuildForHost.interpreter} setup.py build --cmake-only
    ${getExe' cmake "cmake"} build
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

  # PyTorch doesn't use CMake to get variables -- instead, its setup.py has a bunch of known environment variables
  # that it captures and uses to configure the build. We need to set these variables in the environment before
  # running the build.
  env =
    {
      # Pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
      # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
      NIX_CFLAGS_COMPILE = toString (
        [
          "-Wno-unused-command-line-argument"
          "-Wno-uninitialized"
          "-Wno-array-bounds"
          "-Wno-free-nonheap-object"
          "-Wno-unused-result"
        ]
        # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
        # (upstream seems to have fixed this in the wrong place?)
        # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
        # https://github.com/pytorch/pytorch/issues/22346
        ++ optionals (blas.implementation == "mkl") [ "-Wno-error=array-bounds" ]
        # Suppress gcc regression: avx512 math function raises uninitialized variable warning
        # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105593
        # See also: Fails to compile with GCC 12.1.0 https://github.com/pytorch/pytorch/issues/77939
        ++ optionals (cc.isGNU && versionAtLeast cc.version "12.0.0") [
          "-Wno-error=maybe-uninitialized"
          "-Wno-error=uninitialized"
        ]
        # Since pytorch 2.0:
        # gcc-12.2.0/include/c++/12.2.0/bits/new_allocator.h:158:33: error: ‘void operator delete(void*, std::size_t)’
        # ... called on pointer ‘<unknown>’ with nonzero offset [1, 9223372036854775800] [-Werror=free-nonheap-object]
        ++ optionals (cc.isGNU && major cc.version == "12") [ "-Wno-error=free-nonheap-object" ]
        # .../source/torch/csrc/autograd/generated/python_functions_0.cpp:85:3:
        # error: cast from ... to ... converts to incompatible function type [-Werror,-Wcast-function-type-strict]
        ++ optionals (cc.isClang && versionAtLeast cc.version "16") [
          "-Wno-error=cast-function-type-strict"
          # Suppresses the most spammy warnings.
          # This is mainly to fix https://github.com/NixOS/nixpkgs/issues/266895.
        ]
        ++ optionals rocmSupport [
          "-Wno-#warnings"
          "-Wno-cpp"
          "-Wno-unknown-warning-option"
          "-Wno-ignored-attributes"
          "-Wno-deprecated-declarations"
          "-Wno-defaulted-function-deleted"
          "-Wno-pass-failed"
        ]
        ++ optionals cc.isGNU [
          "-Wno-maybe-uninitialized"
          "-Wno-stringop-overflow"
        ]
      );

      # Override the (weirdly) wrong version set by default. See
      # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
      # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
      PYTORCH_BUILD_VERSION = version;
      PYTORCH_BUILD_NUMBER = "0";

      BUILD_NAMEDTENSOR = setBool true;
      BUILD_DOCS = setBool buildDocs;

      # We only do an imports check, so do not build tests either.
      BUILD_TEST = setBool false;

      # Unlike MKL, oneDNN (née MKLDNN) is FOSS, so we enable support for
      # it by default. PyTorch currently uses its own vendored version
      # of oneDNN through Intel iDeep.
      USE_MKLDNN = setBool mklDnnSupport;
      USE_MKLDNN_CBLAS = env.USE_MKLDNN;

      # Avoid using pybind11 from git submodule
      # Also avoids pytorch exporting the headers of pybind11
      USE_SYSTEM_PYBIND11 = setBool true;

      # NB technical debt: building without NNPACK as workaround for missing `six`
      USE_NNPACK = setBool false;

      # In-tree builds of NCCL are not supported.
      # Use NCCL when cudaSupport is enabled and nccl is available.
      USE_NCCL = setBool useSystemNccl;
      USE_SYSTEM_NCCL = env.USE_NCCL;
      USE_STATIC_NCCL = env.USE_NCCL;
    }
    // optionalAttrs cudaSupport {
      # NOTE(@connorbaker): Though we do not disable Gloo or MPI when building with CUDA support, caution should be taken
      # when using the different backends. Gloo's GPU support isn't great, and MPI and CUDA can't be used at the same
      # time without extreme care to ensure they don't lock each other out of shared resources.
      # For more, see https://github.com/open-mpi/ompi/issues/7733#issuecomment-629806195.
      TORCH_CUDA_ARCH_LIST = gpuTargetString;
      CUPTI_INCLUDE_DIR = "${cuda_cupti.dev}/include";
      CUPTI_LIBRARY_DIR = "${cuda_cupti.lib}/lib";
    }
    // optionalAttrs (cudaSupport && cudnn != null) {
      CUDNN_INCLUDE_DIR = "${cudnn.dev}/include";
      CUDNN_LIB_DIR = "${cudnn.lib}/lib";
    }
    // optionalAttrs rocmSupport {
      ROCM_PATH = "${rocmtoolkit_joined}";
      ROCM_SOURCE_DIR = env.ROCM_PATH;
      PYTORCH_ROCM_ARCH = gpuTargetString;
      CMAKE_CXX_FLAGS = "-I${rocmtoolkit_joined}/include -I${rocmtoolkit_joined}/include/rocblas";
    };

  nativeBuildInputs =
    [
      cmake
      which
      ninja
      pybind11
      pythonRelaxDepsHook
      removeReferencesTo
    ]
    ++ optionals cudaSupport [
      autoAddDriverRunpath
      cuda_nvcc
    ]
    ++ optionals rocmSupport [ rocmtoolkit_joined ];

  buildInputs =
    [
      blas
      blas.provider
    ]
    ++ optionals cudaSupport cudaBuildInputs
    ++ optionals rocmSupport [ rocmPackages.llvm.openmp ]
    ++ optionals (cudaSupport || rocmSupport) [ magma ]
    ++ optionals isLinux [ numactl ]
    ++ optionals isDarwin [
      Accelerate
      CoreServices
      libobjc
    ]
    ++ optionals tritonSupport [ openai-triton ]
    ++ optionals MPISupport [ mpi ]
    ++ optionals rocmSupport [ rocmtoolkit_joined ];

  dependencies = [
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
  ] ++ optionals tritonSupport [ openai-triton ];

  propagatedCxxBuildInputs =
    [ ] ++ optionals MPISupport [ mpi ] ++ optionals rocmSupport [ rocmtoolkit_joined ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;

  pythonImportsCheck = [ "torch" ];

  nativeCheckInputs = [
    hypothesis
    ninja
    psutil
  ];

  checkPhase = concatStringsSep " " [
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
      find \
        "$out/${python.sitePackages}/torch/include" \
        "$out/${python.sitePackages}/torch/lib" \
        -type f -exec remove-references-to -t ${cc} '{}' +

      mkdir $dev
      cp -r $out/${python.sitePackages}/torch/include $dev/include
      cp -r $out/${python.sitePackages}/torch/share $dev/share

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
    ''
    + optionalString rocmSupport ''
      substituteInPlace $dev/share/cmake/Tensorpipe/TensorpipeTargets-release.cmake \
        --replace-fail "\''${_IMPORT_PREFIX}/lib64" "$lib/lib"

      substituteInPlace $dev/share/cmake/ATen/ATenConfig.cmake \
        --replace-fail "/build/source/torch/include" "$dev/include"
    '';

  postFixup =
    ''
      mkdir -p "$cxxdev/nix-support"
      printWords "''${propagatedCxxBuildInputs[@]}" >> "$cxxdev/nix-support/propagated-build-inputs"
    ''
    + optionalString isDarwin ''
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
  extraRunpaths = optionals cudaSupport [ "${cuda_nvrtc.lib}/lib" ];
  postPhases = optionals isLinux [ "postPatchelfPhase" ];
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
      cudnn
      rocmSupport
      rocmPackages
      ;
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
    # To help debug when a package is broken due to CUDA support
    inherit brokenConditions;
    cudaCapabilities = if cudaSupport then supportedCudaCapabilities else [ ];
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
    platforms = with lib.platforms; linux ++ optionals (!cudaSupport && !rocmSupport) darwin;
    broken = builtins.any id (builtins.attrValues brokenConditions);
  };
}
