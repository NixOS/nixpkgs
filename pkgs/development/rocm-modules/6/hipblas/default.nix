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
  # for passthru.tests
  hipblas,
}:

# Can also use cuBLAS
stdenv.mkDerivation (finalAttrs: {
  pname = "hipblas";
  version = "6.4.3";

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
    hash = "sha256-lQv8Ik6+0ldqyeJ05CSGB0309nIpzlRL3CRYeQxVfd0=";
  };

  patches = [
    (fetchpatch {
      # Subject: [PATCH] Add gfx1150, gfx1150, gfx1200, gfx1201 support (#1055)
      # This was merged to release/rocm-rel-6.4 but AMD forgot to tag it for 6.4.3
      name = "release-6.4-arch-extra.patch";
      url = "https://github.com/ROCm/hipBLAS/commit/0100b32ccff9a0f12134694315b4e44884e25a8e.patch";
      hash = "sha256-BmktlLJpYaTcogHzEKpZdCnksIIysEO47WMezXoxvCs=";
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

  meta = with lib; {
    description = "ROCm BLAS marshalling library";
    homepage = "https://github.com/ROCm/hipBLAS";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
