{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  python3,
  tensile,
  msgpack,
  libxml2,
  gtest,
  gfortran,
  openmp,
  git,
  amd-blis,
  zstd,
  hipblas-common,
  hipblaslt,
  python3Packages,
  rocm-smi,
  buildTensile ? true,
  buildTests ? true,
  buildBenchmarks ? true,
  # https://github.com/ROCm/Tensile/issues/1757
  # Allows gfx101* users to use rocBLAS normally.
  # Turn the below two values to `true` after the fix has been cherry-picked
  # into a release. Just backporting that single fix is not enough because it
  # depends on some previous commits.
  tensileSepArch ? true,
  tensileLazyLib ? true,
  withHipBlasLt ? true,
  # `gfx940`, `gfx941` are not present in this list because they are early
  # engineering samples, and all final MI300 hardware are `gfx942`:
  # https://github.com/NixOS/nixpkgs/pull/298388#issuecomment-2032791130
  #
  # `gfx1012` is not present in this list because the ISA compatibility patches
  # would force all `gfx101*` GPUs to run as `gfx1010`, so `gfx101*` GPUs will
  # always try to use `gfx1010` code objects, hence building for `gfx1012` is
  # useless: https://github.com/NixOS/nixpkgs/pull/298388#issuecomment-2076327152
  gpuTargets ? (
    clr.localGpuTargets or [
      "gfx900"
      "gfx906"
      "gfx908"
      "gfx90a"
      "gfx942"
      "gfx1010"
      "gfx1030"
      "gfx1100"
      "gfx1101"
      "gfx1102"
      "gfx1151"
      "gfx1200"
      "gfx1201"
    ]
  ),
}:

let
  gpuTargets' = lib.concatStringsSep ";" gpuTargets;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas${clr.gpuArchSuffix}";
  version = "6.3.3";

  outputs = [
    "out"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-IYcrVcGH4yZDkFZeNOJPfG0qsPS/WiH0fTSUSdo1BH4=";
  };

  nativeBuildInputs = [
    cmake
    # no ninja, it buffers console output and nix times out long periods of no output
    rocm-cmake
    clr
    git
  ]
  ++ lib.optionals buildTensile [
    tensile
  ];

  buildInputs = [
    python3
    hipblas-common
  ]
  ++ lib.optionals withHipBlasLt [
    hipblaslt
  ]
  ++ lib.optionals buildTensile [
    zstd
    msgpack
    libxml2
    python3Packages.msgpack
    python3Packages.zstandard
  ]
  ++ lib.optionals buildTests [
    gtest
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    gfortran
    openmp
    amd-blis
    rocm-smi
  ]
  ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
    python3Packages.pyyaml
  ];

  dontStrip = true;
  env.CXXFLAGS =
    "-O3 -DNDEBUG -I${hipblas-common}/include"
    + lib.optionalString (buildTests || buildBenchmarks) " -I${amd-blis}/include/blis";
  # Fails to link tests if we don't add amd-blis libs
  env.LDFLAGS = lib.optionalString (
    buildTests || buildBenchmarks
  ) "-Wl,--as-needed -L${amd-blis}/lib -lblis-mt -lcblas";
  env.TENSILE_ROCM_ASSEMBLER_PATH = "${stdenv.cc}/bin/clang++";

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "CMAKE_VERBOSE_MAKEFILE" true)
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
    # Temporarily set variables to work around upstream CMakeLists issue
    # Can be removed once https://github.com/ROCm/rocm-cmake/issues/121 is fixed
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ]
  ++ lib.optionals buildTensile [
    "-DCPACK_SET_DESTDIR=OFF"
    "-DLINK_BLIS=ON"
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
  ];

  # Pass $NIX_BUILD_CORES to Tensile
  postPatch = ''
    substituteInPlace cmake/build-options.cmake \
      --replace-fail 'Tensile_CPU_THREADS ""' 'Tensile_CPU_THREADS "$ENV{NIX_BUILD_CORES}"'
    substituteInPlace CMakeLists.txt \
      --replace-fail "4.42.0" "4.43.0"
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
