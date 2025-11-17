{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocprim,
  clr,
  gtest,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocthrust";
  version = "6.4.3";

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
    repo = "rocThrust";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-IfMBVISClD1dk7FnAakP2GIpyZFrCnAloFRTaNdSKyw=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    rocprim
    clr
  ];

  buildInputs = lib.optionals buildTests [
    gtest
  ];

  cmakeFlags = [
    "-DHIP_ROOT_DIR=${clr}"
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
    "-DBUILD_BENCHMARKS=ON"
  ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/{test_*,*.hip} $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/benchmark_* $benchmark/bin
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
      rm -rf $out/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "ROCm parallel algorithm library";
    homepage = "https://github.com/ROCm/rocThrust";
    license = with licenses; [ asl20 ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
