{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-smi,
  clr,
  openmp,
  gtest,
  rocblas,
  buildTests ? false, # Will likely fail building because wavefront shifts are not supported for certain archs
  buildExtendedTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
  gpuTargets ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocwmma";
  version = "6.4.3";

  outputs = [
    "out"
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    "test"
  ]
  ++ lib.optionals buildBenchmarks [
    "benchmark"
  ]
  ++ lib.optionals buildSamples [
    "sample"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocWMMA";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-fjyxMrzt74rE7Gf4v4WawYltuw1fvahwZUpauMIE3qc=";
  };

  patches = lib.optionals (buildTests || buildBenchmarks) [
    ./0000-dont-fetch-googletest.patch
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs = [
    openmp
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    rocm-smi
    gtest
    rocblas
  ];

  cmakeFlags = [
    "-DROCWMMA_BUILD_TESTS=${if buildTests || buildBenchmarks then "ON" else "OFF"}"
    "-DROCWMMA_BUILD_SAMPLES=${if buildSamples then "ON" else "OFF"}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals buildExtendedTests [
    "-DROCWMMA_BUILD_EXTENDED_TESTS=ON"
  ]
  ++ lib.optionals buildBenchmarks [
    "-DROCWMMA_BUILD_BENCHMARK_TESTS=ON"
    "-DROCWMMA_BENCHMARK_WITH_ROCBLAS=ON"
  ];

  postInstall =
    lib.optionalString (buildTests || buildBenchmarks) ''
      mkdir -p $test/bin
      mv $out/bin/{*_test,*-validate} $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/*-bench $benchmark/bin
    ''
    + lib.optionalString buildSamples ''
      mkdir -p $sample/bin
      mv $out/bin/sgemmv $sample/bin
      mv $out/bin/simple_gemm $sample/bin
      mv $out/bin/simple_dlrm $sample/bin
    ''
    + lib.optionalString (buildTests || buildBenchmarks || buildSamples) ''
      rm -rf $out/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Mixed precision matrix multiplication and accumulation";
    homepage = "https://github.com/ROCm/rocWMMA";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
