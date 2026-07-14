{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  gtest,
  gbenchmark,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprim";
  version = "7.2.3";

  outputs = [
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
    repo = "rocm-libraries";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/rocprim"
      "shared"
    ];
    hash = "sha256-e0mZ27OXyblcnXQGv2ex/CvWx9smw6nBbHZIijj7lP8=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/rocprim";

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs =
    lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals buildBenchmarks [
      gbenchmark
    ];

  cmakeFlags = [
    "-DHIP_CXX_COMPILER=amdclang++"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ]
  ++ lib.optionals buildTests [
    "-DBUILD_TEST=ON"
  ]
  ++ lib.optionals buildBenchmarks [
    "-DBUILD_BENCHMARK=ON"
  ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/test_* $test/bin
      mv $out/bin/rocprim $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/benchmark_* $benchmark/bin
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
      rmdir $out/bin
    '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "ROCm parallel primitives";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/rocprim";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
