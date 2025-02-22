{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocblas,
  rocprim,
  rocsparse,
  clr,
  fmt,
  gtest,
  gfortran,
  lapack-reference,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? (
    clr.localGpuTargets or [
      "gfx900"
      "gfx906"
      "gfx908"
      "gfx90a"
      "gfx942"
      "gfx1010"
      "gfx1030"
      "gfx1100"
      "gfx1101"
      "gfx1102"
    ]
  ),
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocsolver${clr.gpuArchSuffix}";
  version = "6.3.1";

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
    repo = "rocSOLVER";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-+sGU+0CB48iolJSyYo+xH36q5LCUp+nKtOYbguzMuhg=";
  };

  nativeBuildInputs =
    [
      cmake
      # no ninja, it buffers console output and nix times out long periods of no output
      rocm-cmake
      clr
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      gfortran
    ];

  buildInputs =
    [
      # FIXME: rocblas and rocsolver can't build in parallel
      # but rocsolver doesn't need rocblas' offload builds at build time
      # could we build against a rocblas-minimal?
      rocblas
      rocprim
      rocsparse
      fmt
    ]
    ++ lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      lapack-reference
    ];

  # Reduce parallelism of build to account for internal parallelism from HIP_CLANG_NUM_PARALLEL_JOBS
  preConfigure = ''
    export NIX_BUILD_CORES=$((1 + NIX_BUILD_CORES/10))
    makeFlagsArray+=("-l$(nproc)")
  '';
  cmakeFlags =
    [
      "-DHIP_CLANG_NUM_PARALLEL_JOBS=10"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_VERBOSE_MAKEFILE=ON"
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
      "-DBUILD_CLIENTS_TESTS=ON"
    ]
    ++ lib.optionals buildBenchmarks [
      "-DBUILD_CLIENTS_BENCHMARKS=ON"
    ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/rocsolver-test $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/rocsolver-bench $benchmark/bin
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
      rmdir $out/bin
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  enableParallelBuilding = true;
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "ROCm LAPACK implementation";
    homepage = "https://github.com/ROCm/rocSOLVER";
    license = with licenses; [ bsd2 ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    timeout = 14400; # 4 hours
    maxSilent = 14400; # 4 hours
  };
})
