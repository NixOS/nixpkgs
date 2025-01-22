{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocblas,
  rocsparse,
  rocprim,
  rocrand,
  clr,
  git,
  openmp,
  openmpi,
  gtest,
  buildTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
  gpuTargets ? [ ], # gpuTargets = [ "gfx803" "gfx900:xnack-" "gfx906:xnack-" ... ]
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocalution";
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
    ]
    ++ lib.optionals buildSamples [
      "sample"
    ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocALUTION";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-mrN+CI2mqaMi8oKxui7HAIE2qSn50aNaFipkWwYMtbc=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
    git
  ];

  buildInputs =
    [
      rocblas
      rocsparse
      rocprim
      rocrand
      openmp
      openmpi
    ]
    ++ lib.optionals buildTests [
      gtest
    ];

  cmakeFlags =
    [
      "-DCMAKE_CXX_COMPILER=hipcc"
      "-DROCM_PATH=${clr}"
      "-DHIP_ROOT_DIR=${clr}"
      "-DSUPPORT_HIP=ON"
      "-DSUPPORT_OMP=ON"
      "-DSUPPORT_MPI=ON"
      "-DBUILD_CLIENTS_SAMPLES=${if buildSamples then "ON" else "OFF"}"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ]
    ++ lib.optionals (gpuTargets != [ ]) [
      "-DAMDGPU_TARGETS=${lib.strings.concatStringsSep ";" gpuTargets}"
    ]
    ++ lib.optionals buildTests [
      "-DBUILD_CLIENTS_TESTS=ON"
    ]
    ++ lib.optionals buildBenchmarks [
      "-DBUILD_CLIENTS_BENCHMARKS=ON"
    ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/rocalution-test $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/rocalution-bench $benchmark/bin
    ''
    + lib.optionalString buildSamples ''
      mkdir -p $sample/bin
      mv clients/staging/* $sample/bin
      rm $sample/bin/rocalution-test || true
      rm $sample/bin/rocalution-bench || true

      patchelf --set-rpath \
        $out/lib:${lib.makeLibraryPath (finalAttrs.buildInputs ++ [ clr ])} \
        $sample/bin/*
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
    description = "Iterative sparse solvers for ROCm";
    homepage = "https://github.com/ROCm/rocALUTION";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "7.0.0";
  };
})
