{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  gtest,
  gbenchmark,
  buildTests ? false,
  buildBenchmarks ? false,
  gpuTargets ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocprim";
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
    repo = "rocPRIM";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-0aHxpBuYIYhI2UER45YhHHL5YcxA+XeXoihcUs2AmCo=";
  };

  patches = [ ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs =
    lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals buildBenchmarks [
      gbenchmark
    ];

  cmakeFlags =
    [
      "-DCMAKE_BUILD_TYPE=Release"
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
      mv $out/bin/rocprim $test/bin
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
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "ROCm parallel primitives";
    homepage = "https://github.com/ROCm/rocPRIM";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
  };
})
