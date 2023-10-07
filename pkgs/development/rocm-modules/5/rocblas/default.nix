{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, runCommand
, cmake
, rocm-cmake
, clr
, python3
, tensile
, msgpack
, libxml2
, gtest
, gfortran
, openmp
, amd-blis
, python3Packages
, buildTensile ? true
, buildTests ? false
, buildBenchmarks ? false
, tensileLogic ? "asm_full"
, tensileCOVersion ? "default"
, tensileSepArch ? true
, tensileLazyLib ? true
, tensileLibFormat ? "msgpack"
, gpuTargets ? [ "all" ]
}:
let
  rocblas = stdenv.mkDerivation (finalAttrs: {
    pname = "rocblas";
    version = "5.7.0";

    outputs = [
      "out"
    ] ++ lib.optionals buildTests [
      "test"
    ] ++ lib.optionals buildBenchmarks [
      "benchmark"
    ];

    src = fetchFromGitHub {
      owner = "ROCmSoftwarePlatform";
      repo = "rocBLAS";
      rev = "rocm-${finalAttrs.version}";
      hash = "sha256-3wKnwvAra8u9xqlC05wUD+gSoBILTVJFU2cIV6xv3Lk=";
    };

    nativeBuildInputs = [
      cmake
      rocm-cmake
      clr
    ];

    buildInputs = [
      python3
    ] ++ lib.optionals buildTensile [
      msgpack
      libxml2
      python3Packages.msgpack
      python3Packages.joblib
    ] ++ lib.optionals buildTests [
      gtest
    ] ++ lib.optionals (buildTests || buildBenchmarks) [
      gfortran
      openmp
      amd-blis
    ] ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
      python3Packages.pyyaml
    ];

    cmakeFlags = [
      "-DCMAKE_C_COMPILER=hipcc"
      "-DCMAKE_CXX_COMPILER=hipcc"
      "-Dpython=python3"
      "-DAMDGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
      "-DBUILD_WITH_TENSILE=${if buildTensile then "ON" else "OFF"}"
      # Manually define CMAKE_INSTALL_<DIR>
      # See: https://github.com/NixOS/nixpkgs/pull/197838
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ] ++ lib.optionals buildTensile [
      "-DVIRTUALENV_HOME_DIR=/build/source/tensile"
      "-DTensile_TEST_LOCAL_PATH=/build/source/tensile"
      "-DTensile_ROOT=/build/source/tensile/lib/python${python3.pythonVersion}/site-packages/Tensile"
      "-DTensile_LOGIC=${tensileLogic}"
      "-DTensile_CODE_OBJECT_VERSION=${tensileCOVersion}"
      "-DTensile_SEPARATE_ARCHITECTURES=${if tensileSepArch then "ON" else "OFF"}"
      "-DTensile_LAZY_LIBRARY_LOADING=${if tensileLazyLib then "ON" else "OFF"}"
      "-DTensile_LIBRARY_FORMAT=${tensileLibFormat}"
    ] ++ lib.optionals buildTests [
      "-DBUILD_CLIENTS_TESTS=ON"
    ] ++ lib.optionals buildBenchmarks [
      "-DBUILD_CLIENTS_BENCHMARKS=ON"
    ] ++ lib.optionals (buildTests || buildBenchmarks) [
      "-DCMAKE_CXX_FLAGS=-I${amd-blis}/include/blis"
    ];

    # Tensile REALLY wants to write to the nix directory if we include it normally
    postPatch = lib.optionalString buildTensile ''
      cp -a ${tensile} tensile
      chmod +w -R tensile

      # Rewrap Tensile
      substituteInPlace tensile/bin/{.t*,.T*,*} \
        --replace "${tensile}" "/build/source/tensile"

      substituteInPlace CMakeLists.txt \
        --replace "include(virtualenv)" "" \
        --replace "virtualenv_install(\''${Tensile_TEST_LOCAL_PATH})" ""
    '';

    postInstall = lib.optionalString buildTests ''
      mkdir -p $test/bin
      cp -a $out/bin/* $test/bin
      rm $test/bin/*-bench || true
    '' + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      cp -a $out/bin/* $benchmark/bin
      rm $benchmark/bin/*-test || true
    '' + lib.optionalString (buildTests || buildBenchmarks ) ''
      rm -rf $out/bin
    '';

    passthru.updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
    };

    requiredSystemFeatures = [ "big-parallel" ];

    meta = with lib; {
      description = "BLAS implementation for ROCm platform";
      homepage = "https://github.com/ROCmSoftwarePlatform/rocBLAS";
      license = with licenses; [ mit ];
      maintainers = teams.rocm.members;
      platforms = platforms.linux;
      broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
    };
  });

  gfx80 = runCommand "rocblas-gfx80" { preferLocalBuild = true; } ''
    mkdir -p $out/lib/rocblas/library
    cp -a ${rocblas}/lib/rocblas/library/*gfx80* $out/lib/rocblas/library
  '';

  gfx90 = runCommand "rocblas-gfx90" { preferLocalBuild = true; } ''
    mkdir -p $out/lib/rocblas/library
    cp -a ${rocblas}/lib/rocblas/library/*gfx90* $out/lib/rocblas/library
  '';

  gfx94 = runCommand "rocblas-gfx94" { preferLocalBuild = true; } ''
    mkdir -p $out/lib/rocblas/library
    cp -a ${rocblas}/lib/rocblas/library/*gfx94* $out/lib/rocblas/library
  '';

  gfx10 = runCommand "rocblas-gfx10" { preferLocalBuild = true; } ''
    mkdir -p $out/lib/rocblas/library
    cp -a ${rocblas}/lib/rocblas/library/*gfx10* $out/lib/rocblas/library
  '';

  gfx11 = runCommand "rocblas-gfx11" { preferLocalBuild = true; } ''
    mkdir -p $out/lib/rocblas/library
    cp -a ${rocblas}/lib/rocblas/library/*gfx11* $out/lib/rocblas/library
  '';
in stdenv.mkDerivation (finalAttrs: {
  inherit (rocblas) pname version src passthru meta;

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -a --no-preserve=mode ${rocblas}/* $out
    ln -sf ${gfx80}/lib/rocblas/library/* $out/lib/rocblas/library
    ln -sf ${gfx90}/lib/rocblas/library/* $out/lib/rocblas/library
    ln -sf ${gfx94}/lib/rocblas/library/* $out/lib/rocblas/library
    ln -sf ${gfx10}/lib/rocblas/library/* $out/lib/rocblas/library
    ln -sf ${gfx11}/lib/rocblas/library/* $out/lib/rocblas/library
  '' + lib.optionalString buildTests ''
    cp -a ${rocblas.test} $test
  '' + lib.optionalString buildBenchmarks ''
    cp -a ${rocblas.benchmark} $benchmark
  '' + ''
    runHook postInstall
  '';
})
