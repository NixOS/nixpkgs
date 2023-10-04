{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, clr
, git
, rocfft
, gtest
, boost
, fftw
, fftwFloat
, openmp
, buildTests ? false
, buildBenchmarks ? false
, buildSamples ? false
, gpuTargets ? [ ]
}:

# Can also use cuFFT
stdenv.mkDerivation (finalAttrs: {
  pname = "hipfft";
  version = "5.7.0";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ] ++ lib.optionals buildSamples [
    "sample"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "hipFFT";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-fuYRKdlTrRMwxr3cgMeT3YniPzs4nuvF8YCzr3LLPFM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    clr
    git
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocfft
  ] ++ lib.optionals (buildTests || buildBenchmarks || buildSamples) [
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
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DBUILD_CLIENTS_TESTS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DBUILD_CLIENTS_RIDER=ON"
  ] ++ lib.optionals buildSamples [
    "-DBUILD_CLIENTS_SAMPLES=ON"
  ];

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/hipfft-test $test/bin
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    mv $out/bin/hipfft-rider $benchmark/bin
  '' + lib.optionalString buildSamples ''
    mkdir -p $sample/bin
    mv clients/staging/hipfft_* $sample/bin
    patchelf $sample/bin/hipfft_* --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE"
  '' + lib.optionalString (buildTests || buildBenchmarks) ''
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "FFT marshalling library";
    homepage = "https://github.com/ROCmSoftwarePlatform/hipFFT";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
