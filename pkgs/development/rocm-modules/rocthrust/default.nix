{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  rocm-cmake,
  rocprim,
  clr,
  gtest,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "projects/rocthrust";
    hash = "sha256-hTVzLvoUCo3yDQ2dwcNCHTmqIaJRviT6wFoDUFFlWRI=";
    src = fetchRocmMonorepoSource {
      inherit
        hash
        repo
        sourceSubdir
        version
        ;
    };
    sourceRoot = "${src.name}/${sourceSubdir}";
    homepage = "https://github.com/ROCm/${repo}/tree/rocm-${version}/${sourceSubdir}";
  };
in
stdenv.mkDerivation {
  pname = "rocthrust";
  inherit (source) version src sourceRoot;

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ]
  ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

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

  meta = {
    inherit (source) homepage;
    description = "ROCm parallel algorithm library";
    license = with lib.licenses; [ asl20 ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
