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
  gbenchmark,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

# CUB can also be used as a backend instead of rocPRIM.
let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "projects/hipcub";
    hash = "sha256-YZsUU1GujXV094+0+n92SyK692wHZCVE7fFWAdLU9eA=";
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
  pname = "hipcub";
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
    clr
  ];

  buildInputs = [
    rocprim
  ]
  ++ lib.optionals buildTests [
    gtest
  ]
  ++ lib.optionals buildBenchmarks [
    gbenchmark
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

  meta = {
    inherit (source) homepage;
    description = "Thin wrapper library on top of rocPRIM or CUB";
    license = with lib.licenses; [ bsd3 ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
