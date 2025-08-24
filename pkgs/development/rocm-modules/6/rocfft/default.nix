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
  gpuTargets ? clr.localGpuTargets or clr.gpuTargets,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocfft${clr.gpuArchSuffix}";
  version = "6.3.3";

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "rocFFT";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-RrxdwZ64uC7lQzyJI1eGHX2dmRnW8TfNThnuvuz5XWo=";
  };

  nativeBuildInputs = [
    cmake
    clr
    python3
    rocm-cmake
  ];

  # FIXME: rocfft_aot_helper runs at the end of the build and has a risk of timing it out
  # due to a long period with no terminal output
  buildInputs = [ sqlite ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DSQLITE_USE_SYSTEM_PACKAGE=ON"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ]
  ++ lib.optionals (gpuTargets != [ ]) [
    "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
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
      ];

      cmakeFlags = [
        "-DCMAKE_C_COMPILER=hipcc"
        "-DCMAKE_CXX_COMPILER=hipcc"
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

      cmakeFlags = [
        "-DCMAKE_C_COMPILER=hipcc"
        "-DCMAKE_CXX_COMPILER=hipcc"
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

      cmakeFlags = [
        "-DCMAKE_C_COMPILER=hipcc"
        "-DCMAKE_CXX_COMPILER=hipcc"
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
