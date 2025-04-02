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
  gbenchmark,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? [ ],
}:

# CUB can also be used as a backend instead of rocPRIM.
stdenv.mkDerivation (finalAttrs: {
  pname = "hipcub";
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
    repo = "hipCUB";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-8QzVgj0JSb86zEG3sj5AAt9pG3frw+xrjEOTo7xCIrc=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs =
    [
      rocprim
    ]
    ++ lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals buildBenchmarks [
      gbenchmark
    ];

  cmakeFlags =
    [
      "-DCMAKE_CXX_COMPILER=hipcc"
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
      "-DBUILD_BENCHMARK=ON"
    ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/test_* $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/benchmark_* $benchmark/bin
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
      rmdir $out/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Thin wrapper library on top of rocPRIM or CUB";
    homepage = "https://github.com/ROCm/hipCUB";
    license = with licenses; [ bsd3 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
