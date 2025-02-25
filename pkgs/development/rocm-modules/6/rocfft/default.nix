{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "6.3.1";

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

  # FIXME: rocfft_aot_helper times out build due to no logs!!
  buildInputs = [ sqlite ];

  patches = [
    (fetchpatch {
      name = "allow-setting-rocfft_concurrency-using-envvar.patch";
      url = "https://github.com/GZGavinZhao/rocFFT/commit/627e0d15cf38a32227ce3f0a847054987eef4476.patch";
      hash = "sha256-NuawjU/DQA5rpefXIMCN4uwmIZI0DitYqbnujScYO+Y=";
    })
  ];

  postPatch = ''
    export ROCFFT_CONCURRENCY=$NIX_BUILD_CORES
  '';

  cmakeFlags =
    [
      (lib.cmakeFeature "CMAKE_CXX_COMPILER" "${clr.hipClangPath}/clang++")
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

  hardeningDisable = [ "zerocallusedregs" "stackprotector" ];

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
    maintainers = with maintainers; [ kira-bruneau ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
