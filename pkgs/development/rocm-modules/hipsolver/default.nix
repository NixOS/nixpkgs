{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
  cmake,
  rocm-cmake,
  clr,
  gfortran,
  rocblas,
  rocsolver,
  rocsparse,
  suitesparse,
  gtest,
  lapack-reference,
  buildTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
}:

# Can also use cuSOLVER
let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "projects/hipsolver";
    hash = "sha256-ZINsCwNTJnqtvl01dFJHBqQJttdH25aTRvBJSagaxco=";
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
  pname = "hipsolver";
  inherit (source) version src sourceRoot;

  outputs = [
    "out"
  ]
  ++ lib.optionals buildTests [
    "test"
  ]
  ++ lib.optionals buildBenchmarks [
    "benchmark"
  ]
  ++ lib.optionals buildSamples [
    "sample"
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    gfortran
  ];

  buildInputs = [
    rocblas
    rocsolver
    rocsparse
    suitesparse
  ]
  ++ lib.optionals buildTests [
    gtest
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    lapack-reference
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DBUILD_WITH_SPARSE=OFF" # FIXME: broken - can't find suitesparse/cholmod, looks fixed in master
  ]
  ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ]
  ++ lib.optionals buildBenchmarks [
    "-DBUILD_CLIENTS_BENCHMARKS=ON"
  ]
  ++ lib.optionals buildSamples [
    "-DBUILD_CLIENTS_SAMPLES=ON"
  ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/hipsolver-test $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/hipsolver-bench $benchmark/bin
    ''
    + lib.optionalString buildSamples ''
      mkdir -p $sample/bin
      mv clients/staging/example-* $sample/bin
      patchelf $sample/bin/example-* --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE"
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
      rmdir $out/bin
    '';

  meta = {
    inherit (source) homepage;
    description = "ROCm SOLVER marshalling library";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
}
