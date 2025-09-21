{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  writableTmpDirAsHomeHook,
  cmake,
  rocm-cmake,
  clr,
  python3,
  tensile,
  boost,
  msgpack-cxx,
  libxml2,
  gtest,
  gfortran,
  openmp,
  git,
  amd-blis,
  zstd,
  roctracer,
  hipblas-common,
  hipblaslt,
  python3Packages,
  rocm-smi,
  pkg-config,
  buildTensile ? true,
  buildTests ? true,
  buildBenchmarks ? true,
  tensileSepArch ? true,
  tensileLazyLib ? true,
  withHipBlasLt ? true,
  gpuTargets ? (clr.localGpuTargets or clr.gpuTargets),
}:

let
  gpuTargets' = lib.concatStringsSep ";" gpuTargets;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas${clr.gpuArchSuffix}";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-FCzo/BOk4xLEFkdOdqcCXh4a9t3/OIIBEy8oz6oOMWg=";
  };

  nativeBuildInputs = [
    cmake
    # no ninja, it buffers console output and nix times out long periods of no output
    rocm-cmake
    clr
    git
    pkg-config
  ]
  ++ lib.optionals buildTensile [
    tensile
  ];

  buildInputs = [
    python3
    hipblas-common
    roctracer
    openmp
    amd-blis
  ]
  ++ lib.optionals withHipBlasLt [
    hipblaslt
  ]
  ++ lib.optionals buildTensile [
    zstd
    msgpack-cxx
    libxml2
    python3Packages.msgpack
    python3Packages.zstandard
  ]
  ++ lib.optionals buildTests [
    gtest
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    gfortran
    rocm-smi
  ]
  ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
    python3Packages.pyyaml
  ];

  env.CXXFLAGS = "-fopenmp -I${lib.getDev boost}/include -I${hipblas-common}/include -I${roctracer}/include";
  # Fails to link tests with undefined symbol: cblas_*
  env.LDFLAGS = lib.optionalString (buildTests || buildBenchmarks) "-Wl,--as-needed -lcblas";
  env.TENSILE_ROCM_ASSEMBLER_PATH = "${stdenv.cc}/bin/clang++";

  cmakeFlags = [
    (lib.cmakeFeature "Boost_INCLUDE_DIR" "${lib.getDev boost}/include") # msgpack FindBoost fails to find boost
    (lib.cmakeFeature "CMAKE_EXECUTE_PROCESS_COMMAND_ECHO" "STDERR")
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER" "${lib.getBin gfortran}/bin/gfortran")
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER_AR" "${lib.getBin gfortran}/bin/ar")
    (lib.cmakeFeature "CMAKE_Fortran_COMPILER_RANLIB" "${lib.getBin gfortran}/bin/ranlib")
    (lib.cmakeFeature "python" "python3")
    (lib.cmakeFeature "SUPPORTED_TARGETS" gpuTargets')
    (lib.cmakeFeature "AMDGPU_TARGETS" gpuTargets')
    (lib.cmakeFeature "GPU_TARGETS" gpuTargets')
    (lib.cmakeBool "BUILD_WITH_TENSILE" buildTensile)
    (lib.cmakeBool "ROCM_SYMLINK_LIBS" false)
    (lib.cmakeFeature "ROCBLAS_TENSILE_LIBRARY_DIR" "lib/rocblas")
    (lib.cmakeBool "BUILD_WITH_HIPBLASLT" withHipBlasLt)
    (lib.cmakeBool "BUILD_CLIENTS_TESTS" buildTests)
    (lib.cmakeBool "BUILD_CLIENTS_BENCHMARKS" buildBenchmarks)
    (lib.cmakeBool "BUILD_CLIENTS_SAMPLES" buildBenchmarks)
    (lib.cmakeBool "BUILD_OFFLOAD_COMPRESS" true)
    # # Temporarily set variables to work around upstream CMakeLists issue
    # # Can be removed once https://github.com/ROCm/rocm-cmake/issues/121 is fixed
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ]
  ++ lib.optionals buildTensile [
    "-DCPACK_SET_DESTDIR=OFF"
    "-DLINK_BLIS=ON"
    "-DBLIS_LIB=${amd-blis}/lib/libblis-mt.so"
    "-DBLIS_INCLUDE_DIR=${amd-blis}/include/blis/"
    "-DBLA_PREFER_PKGCONFIG=ON"
    "-DTensile_CODE_OBJECT_VERSION=default"
    "-DTensile_LOGIC=asm_full"
    "-DTensile_LIBRARY_FORMAT=msgpack"
    (lib.cmakeBool "BUILD_WITH_PIP" false)
    (lib.cmakeBool "Tensile_SEPARATE_ARCHITECTURES" tensileSepArch)
    (lib.cmakeBool "Tensile_LAZY_LIBRARY_LOADING" tensileLazyLib)
  ];

  passthru.amdgpu_targets = gpuTargets';

  patches = [
    (fetchpatch {
      name = "Extend-rocBLAS-HIP-ISA-compatibility.patch";
      url = "https://github.com/GZGavinZhao/rocBLAS/commit/89b75ff9cc731f71f370fad90517395e117b03bb.patch";
      hash = "sha256-W/ohOOyNCcYYLOiQlPzsrTlNtCBdJpKVxO8s+4G7sjo=";
    })
    ./hiplaslt-unstable-compat.patch
  ];

  # Pass $NIX_BUILD_CORES to Tensile
  postPatch = ''
    substituteInPlace cmake/build-options.cmake \
      --replace-fail 'Tensile_CPU_THREADS ""' 'Tensile_CPU_THREADS "$ENV{NIX_BUILD_CORES}"'
    substituteInPlace CMakeLists.txt \
      --replace-fail "4.43.0" "4.44.0" \
      --replace-fail '0.10' '1.0'
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "BLAS implementation for ROCm platform";
    homepage = "https://github.com/ROCm/rocBLAS";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
