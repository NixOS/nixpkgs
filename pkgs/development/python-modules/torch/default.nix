{ stdenv, lib, fetchFromGitHub, fetchpatch, buildPythonPackage, python,
  cudaSupport ? false, cudaPackages, magma,
  mklDnnSupport ? true, useSystemNccl ? true,
  MPISupport ? false, mpi,
  buildDocs ? false,

  # Native build inputs
  cmake, util-linux, linkFarm, symlinkJoin, which, pybind11, removeReferencesTo,

  # Build inputs
  numactl,
  CoreServices, libobjc,

  # Propagated build inputs
  numpy, pyyaml, cffi, click, typing-extensions,

  # Unit tests
  hypothesis, psutil,

  # virtual pkg that consistently instantiates blas across nixpkgs
  # See https://github.com/NixOS/nixpkgs/pull/83888
  blas,

  # ninja (https://ninja-build.org) must be available to run C++ extensions tests,
  ninja,

  linuxHeaders_5_19,

  # dependencies for torch.utils.tensorboard
  pillow, six, future, tensorboard, protobuf,

  isPy3k, pythonOlder,

  # ROCm dependencies
  rocmSupport ? false,
  gpuTargets ? [ ],
  openmp, rocm-core, hip, rccl, miopen, miopengemm, rocrand, rocblas,
  rocfft, rocsparse, hipsparse, rocthrust, rocprim, hipcub, roctracer,
  rocsolver, hipfft, hipsolver, hipblas, rocminfo, rocm-thunk, rocm-comgr,
  rocm-device-libs, rocm-runtime, rocm-opencl-runtime, hipify
}:

let
  inherit (cudaPackages) cudatoolkit cudaFlags cudnn nccl;
in

# assert that everything needed for cuda is present and that the correct cuda versions are used
assert !cudaSupport || (let majorIs = lib.versions.major cudatoolkit.version;
                        in majorIs == "9" || majorIs == "10" || majorIs == "11");

# confirm that cudatoolkits are sync'd across dependencies
assert !(MPISupport && cudaSupport) || mpi.cudatoolkit == cudatoolkit;
assert !cudaSupport || magma.cudatoolkit == cudatoolkit;

let
  setBool = v: if v then "1" else "0";
  cudatoolkit_joined = symlinkJoin {
    name = "${cudatoolkit.name}-unsplit";
    # nccl is here purely for semantic grouping it could be moved to nativeBuildInputs
    paths = [ cudatoolkit.out cudatoolkit.lib nccl.dev nccl.out ];
  };

  # Normally libcuda.so.1 is provided at runtime by nvidia-x11 via
  # LD_LIBRARY_PATH=/run/opengl-driver/lib.  We only use the stub
  # libcuda.so from cudatoolkit for running tests, so that we don’t have
  # to recompile pytorch on every update to nvidia-x11 or the kernel.
  cudaStub = linkFarm "cuda-stub" [{
    name = "libcuda.so.1";
    path = "${cudatoolkit}/lib/stubs/libcuda.so";
  }];
  cudaStubEnv = lib.optionalString cudaSupport
    "LD_LIBRARY_PATH=${cudaStub}\${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH ";

  rocmtoolkit_joined = symlinkJoin {
    name = "rocm-merged";

    paths = [
      rocm-core hip rccl miopen miopengemm rocrand rocblas
      rocfft rocsparse hipsparse rocthrust rocprim hipcub
      roctracer rocfft rocsolver hipfft hipsolver hipblas
      rocminfo rocm-thunk rocm-comgr rocm-device-libs
      rocm-runtime rocm-opencl-runtime hipify
    ];
  };
in buildPythonPackage rec {
  pname = "torch";
  # Don't forget to update torch-bin to the same version.
  version = "1.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7.0";

  outputs = [
    "out" # output standard python package
    "dev" # output libtorch headers
    "lib" # output libtorch libraries
  ];

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "pytorch";
    rev = "refs/tags/v${version}";
    fetchSubmodules = true;
    hash = "sha256-yQz+xHPw9ODRBkV9hv1th38ZmUr/fXa+K+d+cvmX3Z8=";
  };

  patches = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # pthreadpool added support for Grand Central Dispatch in April
    # 2020. However, this relies on functionality (DISPATCH_APPLY_AUTO)
    # that is available starting with macOS 10.13. However, our current
    # base is 10.12. Until we upgrade, we can fall back on the older
    # pthread support.
    ./pthreadpool-disable-gcd.diff
  ];

  postPatch = lib.optionalString rocmSupport ''
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
        "set(ROCM_PATH \$ENV{ROCM_PATH})''\nset(ROCM_VERSION ${lib.concatStrings (lib.intersperse "0" (lib.splitString "." hip.version))})"
  '';

  preConfigure = lib.optionalString cudaSupport ''
    export TORCH_CUDA_ARCH_LIST="${cudaFlags.cudaCapabilitiesSemiColonString}"
    export CC=${cudatoolkit.cc}/bin/gcc CXX=${cudatoolkit.cc}/bin/g++
  '' + lib.optionalString (cudaSupport && cudnn != null) ''
    export CUDNN_INCLUDE_DIR=${cudnn}/include
  '' + lib.optionalString rocmSupport ''
    export ROCM_PATH=${rocmtoolkit_joined}
    export ROCM_SOURCE_DIR=${rocmtoolkit_joined}
    export PYTORCH_ROCM_ARCH="${lib.strings.concatStringsSep ";" (if gpuTargets == [ ] then hip.gpuTargets else gpuTargets)}"
    export CMAKE_CXX_FLAGS="-I${rocmtoolkit_joined}/include -I${rocmtoolkit_joined}/include/rocblas"
    python tools/amd_build/build_amd.py
  '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

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
  USE_SYSTEM_BIND11 = true;

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    ${python.interpreter} setup.py build --cmake-only
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

  USE_SYSTEM_NCCL = setBool useSystemNccl;                  # don't build pytorch's third_party NCCL

  # Suppress a weird warning in mkl-dnn, part of ideep in pytorch
  # (upstream seems to have fixed this in the wrong place?)
  # https://github.com/intel/mkl-dnn/commit/8134d346cdb7fe1695a2aa55771071d455fae0bc
  # https://github.com/pytorch/pytorch/issues/22346
  #
  # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
  # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
  NIX_CFLAGS_COMPILE = lib.optionals (blas.implementation == "mkl") [ "-Wno-error=array-bounds" ];

  nativeBuildInputs = [
    cmake
    util-linux
    which
    ninja
    pybind11
    removeReferencesTo
  ] ++ lib.optionals cudaSupport [ cudatoolkit_joined ]
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  buildInputs = [ blas blas.provider pybind11 ]
    ++ lib.optionals stdenv.isLinux [ linuxHeaders_5_19 ] # TMP: avoid "flexible array member" errors for now
    ++ lib.optionals cudaSupport [ cudnn nccl ]
    ++ lib.optionals rocmSupport [ openmp ]
    ++ lib.optionals (cudaSupport || rocmSupport) [ magma ]
    ++ lib.optionals stdenv.isLinux [ numactl ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices libobjc ];

  propagatedBuildInputs = [
    cffi
    click
    numpy
    pyyaml
    typing-extensions
    # the following are required for tensorboard support
    pillow six future tensorboard protobuf
  ] ++ lib.optionals MPISupport [ mpi ]
    ++ lib.optionals rocmSupport [ rocmtoolkit_joined ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;

  pythonImportsCheck = [
    "torch"
  ];

  nativeCheckInputs = [ hypothesis ninja psutil ];

  checkPhase = with lib.versions; with lib.strings; concatStringsSep " " [
    "runHook preCheck"
    cudaStubEnv
    "${python.interpreter} test/run_test.py"
    "--exclude"
    (concatStringsSep " " [
      "utils" # utils requires git, which is not allowed in the check phase

      # "dataloader" # psutils correctly finds and triggers multiprocessing, but is too sandboxed to run -- resulting in numerous errors
      # ^^^^^^^^^^^^ NOTE: while test_dataloader does return errors, these are acceptable errors and do not interfere with the build

      # tensorboard has acceptable failures for pytorch 1.3.x due to dependencies on tensorboard-plugins
      (optionalString (majorMinor version == "1.3" ) "tensorboard")
    ])
    "runHook postCheck"
  ];

  postInstall = ''
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
  '' + lib.optionalString rocmSupport ''
    substituteInPlace $dev/share/cmake/Tensorpipe/TensorpipeTargets-release.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib64" "$lib/lib"

    substituteInPlace $dev/share/cmake/ATen/ATenConfig.cmake \
      --replace "/build/source/torch/include" "$dev/include"
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
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

  # Builds in 2+h with 2 cores, and ~15m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  passthru = {
    inherit cudaSupport cudaPackages;
    # At least for 1.10.2 `torch.fft` is unavailable unless BLAS provider is MKL. This attribute allows for easy detection of its availability.
    blasProvider = blas.provider;
  };

  meta = with lib; {
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # keep PyTorch in the description so the package can be found under that name on search.nixos.org
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh thoughtpolice tscholak ]; # tscholak esp. for darwin-related builds
    platforms = with platforms; linux ++ lib.optionals (!cudaSupport || !rocmSupport) darwin;
    broken = rocmSupport && cudaSupport; # CUDA and ROCm are mutually exclusive
  };
}
