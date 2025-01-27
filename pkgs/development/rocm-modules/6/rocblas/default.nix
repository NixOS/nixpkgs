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
  amd-blis,
  python3Packages,
  buildTensile ? true,
  buildTests ? false,
  buildBenchmarks ? false,
  tensileLogic ? "asm_full",
  tensileCOVersion ? "default",
  # https://github.com/ROCm/Tensile/issues/1757
  # Allows gfx101* users to use rocBLAS normally.
  # Turn the below two values to `true` after the fix has been cherry-picked
  # into a release. Just backporting that single fix is not enough because it
  # depends on some previous commits.
  tensileSepArch ? false,
  tensileLazyLib ? false,
  tensileLibFormat ? "msgpack",
  # `gfx940`, `gfx941` are not present in this list because they are early
  # engineering samples, and all final MI300 hardware are `gfx942`:
  # https://github.com/NixOS/nixpkgs/pull/298388#issuecomment-2032791130
  #
  # `gfx1012` is not present in this list because the ISA compatibility patches
  # would force all `gfx101*` GPUs to run as `gfx1010`, so `gfx101*` GPUs will
  # always try to use `gfx1010` code objects, hence building for `gfx1012` is
  # useless: https://github.com/NixOS/nixpkgs/pull/298388#issuecomment-2076327152
  gpuTargets ? [
    "gfx900;gfx906:xnack-;gfx908:xnack-;gfx90a:xnack+;gfx90a:xnack-;gfx942;gfx1010;gfx1030;gfx1100;gfx1101;gfx1102"
  ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas";
  version = "6.0.2";

  outputs =
    [
      "out"
    ]
    ++ lib.optionals buildTests [
      "test"
    ]
    ++ lib.optionals buildBenchmarks [
      "benchmark"
    ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-G68d/gvBbTdNx8xR3xY+OkBm5Yxq1NFjxby9BbpOcUk=";
  };

  nativeBuildInputs =
    [
      cmake
      rocm-cmake
      clr
    ]
    ++ lib.optionals buildTensile [
      tensile
    ];

  buildInputs =
    [
      python3
    ]
    ++ lib.optionals buildTensile [
      msgpack
      libxml2
      python3Packages.msgpack
      python3Packages.joblib
    ]
    ++ lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      gfortran
      openmp
      amd-blis
    ]
    ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
      python3Packages.pyyaml
    ];

  cmakeFlags =
    [
      (lib.cmakeFeature "CMAKE_C_COMPILER" "hipcc")
      (lib.cmakeFeature "CMAKE_CXX_COMPILER" "hipcc")
      (lib.cmakeFeature "python" "python3")
      (lib.cmakeFeature "AMDGPU_TARGETS" (lib.concatStringsSep ";" gpuTargets))
      (lib.cmakeBool "BUILD_WITH_TENSILE" buildTensile)
      (lib.cmakeBool "ROCM_SYMLINK_LIBS" false)
      (lib.cmakeFeature "ROCBLAS_TENSILE_LIBRARY_DIR" "lib/rocblas")
      (lib.cmakeBool "BUILD_CLIENTS_TESTS" buildTests)
      (lib.cmakeBool "BUILD_CLIENTS_BENCHMARKS" buildBenchmarks)
      # rocblas header files are not installed unless we set this
      (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    ]
    ++ lib.optionals buildTensile [
      (lib.cmakeBool "BUILD_WITH_PIP" false)
      (lib.cmakeFeature "Tensile_LOGIC" tensileLogic)
      (lib.cmakeFeature "Tensile_CODE_OBJECT_VERSION" tensileCOVersion)
      (lib.cmakeBool "Tensile_SEPARATE_ARCHITECTURES" tensileSepArch)
      (lib.cmakeBool "Tensile_LAZY_LIBRARY_LOADING" tensileLazyLib)
      (lib.cmakeFeature "Tensile_LIBRARY_FORMAT" tensileLibFormat)
      (lib.cmakeBool "Tensile_PRINT_DEBUG" true)
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-I${amd-blis}/include/blis")
    ];

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
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "BLAS implementation for ROCm platform";
    homepage = "https://github.com/ROCm/rocBLAS";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
