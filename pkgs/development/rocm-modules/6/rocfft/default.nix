{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  clr,
  python3,
  rocm-cmake,
  sqlite,
  boost,
  fftw,
  fftwFloat,
  gtest,
  openmp,
  rocrand,
  hiprand,
  gpuTargets ? clr.localGpuTargets or clr.gpuTargets,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocfft${clr.gpuArchSuffix}";
  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocFFT";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-yaOjBF2aJkCBlxkydyOsrfT4lNZ0BVkS2jJC0fEiBug=";
  };

  nativeBuildInputs = [
    cmake
    clr
    python3
    rocm-cmake
  ];

  buildInputs = [
    sqlite
    hiprand
  ];

  patches = [
    # Fixes build timeout due to no log output during rocfft_aot step
    ./log-every-n-aot-jobs.patch
  ];

  cmakeFlags = [
    "-DSQLITE_USE_SYSTEM_PACKAGE=ON"
    "-DHIP_PLATFORM=amd"
    "-DBUILD_CLIENTS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DUSE_HIPRAND=ON"
    "-DROCFFT_KERNEL_CACHE_ENABLE=ON"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  passthru = {
    test = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-test";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/clients/tests";

      nativeBuildInputs = [
        cmake
        clr
        rocm-cmake
      ];

      buildInputs = [
        boost
        fftw
        fftwFloat
        finalAttrs.finalPackage
        gtest
        openmp
        rocrand
        hiprand
      ];

      postInstall = ''
        rm -r "$out/lib/fftw"
        rmdir "$out/lib"
      '';
    };

    benchmark = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-benchmark";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/clients/rider";

      nativeBuildInputs = [
        cmake
        clr
        rocm-cmake
      ];

      buildInputs = [
        boost
        finalAttrs.finalPackage
        openmp
        (python3.withPackages (
          ps: with ps; [
            pandas
            scipy
          ]
        ))
        rocrand
      ];

      postInstall = ''
        cp -a ../../../scripts/perf "$out/bin"
      '';
    };

    samples = stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-samples";
      inherit (finalAttrs) version src;

      sourceRoot = "${finalAttrs.src.name}/clients/samples";

      nativeBuildInputs = [
        cmake
        clr
        rocm-cmake
      ];

      buildInputs = [
        boost
        finalAttrs.finalPackage
        openmp
        rocrand
      ];

      installPhase = ''
        runHook preInstall
        mkdir "$out"
        cp -a bin "$out"
        runHook postInstall
      '';
    };

    updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      inherit (finalAttrs.src) owner;
      inherit (finalAttrs.src) repo;
    };
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "FFT implementation for ROCm";
    homepage = "https://github.com/ROCm/rocFFT";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
