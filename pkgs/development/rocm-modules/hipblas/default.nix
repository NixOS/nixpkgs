{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  gfortran,
  hipblas-common,
  rocblas,
  rocsolver,
  rocsparse,
  rocprim,
  gtest,
  lapack-reference,
  buildTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
  # for passthru.tests
  hipblas,
}:

# Can also use cuBLAS
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblas";
  version = "7.1.1";

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

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "hipBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-2wDnYZapJ4fU/JZpy6qOf5+DYuatWmCw/hA8WO5x2T0=";
  };

  postPatch = ''
    substituteInPlace library/CMakeLists.txt \
      --replace-fail "find_package(Git REQUIRED)" ""
  '';

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    gfortran
  ];

  propagatedBuildInputs = [ hipblas-common ];

  buildInputs = [
    rocblas
    rocprim
    rocsparse
    rocsolver
  ]
  ++ lib.optionals buildTests [
    gtest
  ]
  ++ lib.optionals (buildTests || buildBenchmarks) [
    lapack-reference
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=${lib.getExe' clr "amdclang++"}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DBUILD_WITH_SOLVER=ON"
    "-DAMDGPU_TARGETS=${rocblas.amdgpu_targets}"
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
      mv $out/bin/hipblas-test $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/hipblas-bench $benchmark/bin
    ''
    + lib.optionalString buildSamples ''
      mkdir -p $sample/bin
      mv $out/bin/example-* $sample/bin
    ''
    + lib.optionalString (buildTests || buildBenchmarks || buildSamples) ''
      rmdir $out/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };
  passthru.tests.hipblas-tested = hipblas.override {
    buildTests = true;
    buildBenchmarks = true;
    buildSamples = true;
  };

  meta = {
    description = "ROCm BLAS marshalling library";
    homepage = "https://github.com/ROCm/hipBLAS";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
