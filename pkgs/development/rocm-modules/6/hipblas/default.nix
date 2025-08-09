{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
}:

# Can also use cuBLAS
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblas";
  version = "6.3.3";

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
    hash = "sha256-Rz1KAhBUbvErHTF2PM1AkVhqo4OHldfSNMSpp5Tx9yk=";
  };

  patches = [
    # https://github.com/ROCm/hipBLAS/pull/952
    (fetchpatch {
      name = "transitively-depend-hipblas-common.patch";
      url = "https://github.com/ROCm/hipBLAS/commit/54220fdaebf0fb4fd0921ee9e418ace5b143ec8f.patch";
      hash = "sha256-MFEhv8Bkrd2zD0FFIDg9oJzO7ztdyMAF+R9oYA0rmwQ=";
    })
  ];

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
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CXX_COMPILER=${lib.getExe' clr "hipcc"}"
    # Upstream is migrating to amdclang++, it is likely this will be correct in next version bump
    #"-DCMAKE_CXX_COMPILER=${lib.getBin clr}/bin/amdclang++"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
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

  meta = with lib; {
    description = "ROCm BLAS marshalling library";
    homepage = "https://github.com/ROCm/hipBLAS";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
