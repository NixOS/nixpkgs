{
  lib,
  stdenv,
  fetchRocmMonorepoSource,
  rocmVersion,
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

let
  source = rec {
    repo = "rocm-libraries";
    version = rocmVersion;
    sourceSubdir = "projects/rocfft";
    hash = "sha256-2xm82nNFKPsMof7Jeyf5Glye9MbADvswNNELmE0gvSo=";
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
stdenv.mkDerivation (finalAttrs: {
  pname = "rocfft${clr.gpuArchSuffix}";
  inherit (source) version src sourceRoot;

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

      sourceRoot = "${finalAttrs.sourceRoot}/clients/tests";

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

      sourceRoot = "${finalAttrs.sourceRoot}/clients/rider";

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

      sourceRoot = "${finalAttrs.sourceRoot}/clients/samples";

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

  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    inherit (source) homepage;
    description = "FFT implementation for ROCm";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
