{
  rocblas,
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  runCommand,
  cmake,
  rocm-cmake,
  clr,
  python3,
  tensile,
  msgpack,
  libxml2,
  gtest,
  gfortran,
  openmp,
  amd-blis,
  python3Packages,
  buildTensile ? true,
  buildTests ? false,
  buildBenchmarks ? false,
  tensileLogic ? "asm_full",
  tensileCOVersion ? "default",
  tensileSepArch ? true,
  tensileLazyLib ? true,
  tensileLibFormat ? "msgpack",
  gpuTargets ? [ "all" ],
}:

let
  # NOTE: Update the default GPU targets on every update
  gfx80 =
    (rocblas.override {
      gpuTargets = [
        "gfx803"
      ];
    }).overrideAttrs
      { pname = "rocblas-tensile-gfx80"; };

  gfx90 =
    (rocblas.override {
      gpuTargets = [
        "gfx900"
        "gfx906:xnack-"
        "gfx908:xnack-"
        "gfx90a:xnack+"
        "gfx90a:xnack-"
      ];
    }).overrideAttrs
      { pname = "rocblas-tensile-gfx90"; };

  gfx94 =
    (rocblas.override {
      gpuTargets = [
        "gfx940"
        "gfx941"
        "gfx942"
      ];
    }).overrideAttrs
      { pname = "rocblas-tensile-gfx94"; };

  gfx10 =
    (rocblas.override {
      gpuTargets = [
        "gfx1010"
        "gfx1012"
        "gfx1030"
      ];
    }).overrideAttrs
      { pname = "rocblas-tensile-gfx10"; };

  gfx11 =
    (rocblas.override {
      gpuTargets = [
        "gfx1100"
        "gfx1101"
        "gfx1102"
      ];
    }).overrideAttrs
      { pname = "rocblas-tensile-gfx11"; };

  # Unfortunately, we have to do two full builds, otherwise we get overlapping _fallback.dat files
  fallbacks = rocblas.overrideAttrs { pname = "rocblas-tensile-fallbacks"; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocblas";
  version = "5.7.1";

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
    repo = "rocBLAS";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-3wKnwvAra8u9xqlC05wUD+gSoBILTVJFU2cIV6xv3Lk=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs =
    [
      python3
    ]
    ++ lib.optionals buildTensile [
      msgpack
      libxml2
      python3Packages.msgpack
      python3Packages.joblib
    ]
    ++ lib.optionals buildTests [
      gtest
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      gfortran
      openmp
      amd-blis
    ]
    ++ lib.optionals (buildTensile || buildTests || buildBenchmarks) [
      python3Packages.pyyaml
    ];

  cmakeFlags =
    [
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
    ]
    ++ lib.optionals buildTensile [
      "-DVIRTUALENV_HOME_DIR=/build/source/tensile"
      "-DTensile_TEST_LOCAL_PATH=/build/source/tensile"
      "-DTensile_ROOT=/build/source/tensile/${python3.sitePackages}/Tensile"
      "-DTensile_LOGIC=${tensileLogic}"
      "-DTensile_CODE_OBJECT_VERSION=${tensileCOVersion}"
      "-DTensile_SEPARATE_ARCHITECTURES=${if tensileSepArch then "ON" else "OFF"}"
      "-DTensile_LAZY_LIBRARY_LOADING=${if tensileLazyLib then "ON" else "OFF"}"
      "-DTensile_LIBRARY_FORMAT=${tensileLibFormat}"
    ]
    ++ lib.optionals buildTests [
      "-DBUILD_CLIENTS_TESTS=ON"
    ]
    ++ lib.optionals buildBenchmarks [
      "-DBUILD_CLIENTS_BENCHMARKS=ON"
    ]
    ++ lib.optionals (buildTests || buildBenchmarks) [
      "-DCMAKE_CXX_FLAGS=-I${amd-blis}/include/blis"
    ];

  postPatch =
    lib.optionalString (finalAttrs.pname != "rocblas") ''
      # Return early and install tensile files manually
      substituteInPlace library/src/CMakeLists.txt \
        --replace "set_target_properties( TensileHost PROPERTIES OUTPUT_NAME" "return()''\nset_target_properties( TensileHost PROPERTIES OUTPUT_NAME"
    ''
    + lib.optionalString (buildTensile && finalAttrs.pname == "rocblas") ''
      # Link the prebuilt Tensile files
      mkdir -p build/Tensile/library

      for path in ${gfx80} ${gfx90} ${gfx94} ${gfx10} ${gfx11} ${fallbacks}; do
        ln -s $path/lib/rocblas/library/* build/Tensile/library
      done

      unlink build/Tensile/library/TensileManifest.txt
    ''
    + lib.optionalString buildTensile ''
      # Tensile REALLY wants to write to the nix directory if we include it normally
      cp -a ${tensile} tensile
      chmod +w -R tensile

      # Rewrap Tensile
      substituteInPlace tensile/bin/{.t*,.T*,*} \
        --replace "${tensile}" "/build/source/tensile"

      substituteInPlace CMakeLists.txt \
        --replace "include(virtualenv)" "" \
        --replace "virtualenv_install(\''${Tensile_TEST_LOCAL_PATH})" ""
    '';

  postInstall =
    lib.optionalString (finalAttrs.pname == "rocblas") ''
      ln -sf ${fallbacks}/lib/rocblas/library/TensileManifest.txt $out/lib/rocblas/library
    ''
    + lib.optionalString (finalAttrs.pname != "rocblas") ''
      mkdir -p $out/lib/rocblas/library
      rm -rf $out/share
    ''
    +
      lib.optionalString
        (finalAttrs.pname != "rocblas" && finalAttrs.pname != "rocblas-tensile-fallbacks")
        ''
          rm Tensile/library/{TensileManifest.txt,*_fallback.dat}
          mv Tensile/library/* $out/lib/rocblas/library
        ''
    + lib.optionalString (finalAttrs.pname == "rocblas-tensile-fallbacks") ''
      mv Tensile/library/{TensileManifest.txt,*_fallback.dat} $out/lib/rocblas/library
    ''
    + lib.optionalString buildTests ''
      mkdir -p $test/bin
      cp -a $out/bin/* $test/bin
      rm $test/bin/*-bench || true
    ''
    + lib.optionalString buildBenchmarks ''
      mkdir -p $benchmark/bin
      cp -a $out/bin/* $benchmark/bin
      rm $benchmark/bin/*-test || true
    ''
    + lib.optionalString (buildTests || buildBenchmarks) ''
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
    homepage = "https://github.com/ROCm/rocBLAS";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken =
      versions.minor finalAttrs.version != versions.minor stdenv.cc.version
      || versionAtLeast finalAttrs.version "6.0.0";
  };
})
