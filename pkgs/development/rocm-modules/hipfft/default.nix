{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  clr,
  rocfft,
  gtest,
  boost,
  fftw,
  fftwFloat,
  openmp,
  buildTests ? false,
  buildBenchmarks ? false,
  buildSamples ? false,
  gpuTargets ? clr.localGpuTargets or [ ],
}:

# Can also use cuFFT
stdenv.mkDerivation (finalAttrs: {
  pname = "hipfft";
  version = "7.2.1";

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
    repo = "rocm-libraries";
    rev = "rocm-${finalAttrs.version}";
    sparseCheckout = [
      "projects/hipfft"
      "shared"
    ];
    fetchSubmodules = true;
    hash = "sha256-EtxZuxBPx6trTN9iC7uri2+UR0Eolp919Ry4U1PEqNA=";
  };
  sourceRoot = "${finalAttrs.src.name}/projects/hipfft";

  nativeBuildInputs = [
    clr
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocfft
  ]
  ++ lib.optionals (buildTests || buildBenchmarks || buildSamples) [
    gtest
    boost
    fftw
    fftwFloat
    openmp
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DCMAKE_MODULE_PATH=${clr}/lib/cmake/hip"
    "-DHIP_ROOT_DIR=${clr}"
    "-DHIP_PATH=${clr}"
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
    "-DBUILD_CLIENTS_RIDER=ON"
  ]
  ++ lib.optionals buildSamples [
    "-DBUILD_CLIENTS_SAMPLES=ON"
  ];

  postInstall =
    lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv $out/bin/hipfft-test $test/bin
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      mv $out/bin/hipfft-rider $benchmark/bin
    ''
    + lib.optionalString buildSamples ''
      mkdir -p $sample/bin
      mv clients/staging/hipfft_* $sample/bin
      patchelf $sample/bin/hipfft_* --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE"
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
      rmdir $out/bin
    '';

  passthru.updateScript = rocmUpdateScript { inherit finalAttrs; };

  meta = {
    description = "FFT marshalling library";
    homepage = "https://github.com/ROCm/rocm-libraries/tree/develop/projects/hipfft";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
