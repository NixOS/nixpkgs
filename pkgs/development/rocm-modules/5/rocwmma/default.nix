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
  gpuTargets ? [ ], # gpuTargets = [ "gfx908:xnack-" "gfx90a:xnack-" "gfx90a:xnack+" ... ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocwmma";
  version = "5.7.1";

  outputs =
    [
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
    hash = "sha256-0otJxgVYLwvVYIWT/hjrrpuSj5jslP1dbJRt6GUOrDs=";
  };

  patches = lib.optionals (buildTests || buildBenchmarks) [
    ./0000-dont-fetch-googletest.patch
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs =
    [
      openmp
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      rocm-smi
      gtest
      rocblas
    ];

  cmakeFlags =
    [
      "-DCMAKE_CXX_COMPILER=hipcc"
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
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Mixed precision matrix multiplication and accumulation";
    homepage = "https://github.com/ROCm/rocWMMA";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "6.0.0";
  };
})
