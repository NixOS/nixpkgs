{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  cmake,
  rocm-cmake,
  clr,
  openmp,
  rocblas,
  hipblas-common,
  hipblas,
  hipblaslt,
  rocmlir,
  miopen,
  protobuf,
  abseil-cpp,
  half,
  nlohmann_json,
  boost,
  msgpack-cxx,
  sqlite,
  # TODO(@LunNova): Swap to `onednn` once v3 is supported
  # Upstream issue: https://github.com/ROCm/AMDMIGraphX/issues/4351
  onednn_2,
  blaze,
  texliveSmall,
  doxygen,
  sphinx,
  docutils,
  ghostscript,
  python3Packages,
  writableTmpDirAsHomeHook,
  buildDocs ? false,
  buildTests ? false,
  gpuTargets ? clr.gpuTargets,
}:

let
  latex = lib.optionalAttrs buildDocs (
    texliveSmall.withPackages (
      ps: with ps; [
        latexmk
        tex-gyre
        fncychap
        wrapfig
        capt-of
        framed
        needspace
        tabulary
        varwidth
        titlesec
        epstopdf
      ]
    )
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "migraphx";
  version = "7.1.1";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildDocs [
    "doc"
  ]
  ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "AMDMIGraphX";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-s6w4bF7koK4wnf6leVKBzwIB4X2ROHa3EgX6XuJIAew=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
    clr
    python3Packages.python
  ]
  ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    docutils
    ghostscript
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    openmp
    rocblas
    hipblas-common
    hipblas
    hipblaslt
    rocmlir
    miopen
    protobuf
    half
    nlohmann_json
    boost
    msgpack-cxx
    sqlite
    onednn_2
    blaze
    python3Packages.pybind11
    python3Packages.onnx
  ];

  env.LDFLAGS = "-Wl,--allow-shlib-undefined";

  cmakeFlags = [
    "-DMIGRAPHX_ENABLE_GPU=ON"
    "-DMIGRAPHX_ENABLE_CPU=ON"
    "-DMIGRAPHX_ENABLE_FPGA=ON"
    "-DMIGRAPHX_ENABLE_MLIR=ON"
    "-DCMAKE_C_COMPILER=amdclang"
    "-DCMAKE_CXX_COMPILER=amdclang++"
    "-DCMAKE_VERBOSE_MAKEFILE=ON"
    "-DEMBED_USE=CArrays" # Fixes error with lld
    "-DDMIGRAPHX_ENABLE_PYTHON=ON"
    "-DROCM_PATH=${clr}"
    "-DHIP_ROOT_DIR=${clr}"
    # migraphx relies on an incompatible fork of composable_kernel
    # migraphxs relies on miopen which relies on current composable_kernel
    # impossible to build with this ON; we can't link both of them even if we package both
    "-DMIGRAPHX_USE_COMPOSABLEKERNEL=OFF"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  postPatch = ''
    export CXXFLAGS+=" -w -isystem${rocmlir}/include/rocmlir -I${half}/include -I${lib.getInclude abseil-cpp}/include -I${hipblas-common}/include -I${lib.getInclude protobuf}/include"
    patchShebangs tools

    # `error: '__clang_hip_runtime_wrapper.h' file not found [clang-diagnostic-error]`
    substituteInPlace CMakeLists.txt \
      --replace "set(MIGRAPHX_TIDY_ERRORS ALL)" ""

    # Fix Unicode minus sign (U+2212) in comment that breaks EMBED_USE=CArrays
    # The embed mechanism generates char[] arrays that can't store unicode −
    # which has values >127
    substituteInPlace src/targets/gpu/kernels/include/migraphx/kernels/bit.hpp \
      --replace-fail "// popcount(~(x | −x))" "// popcount(~(x | -x))"
  ''
  + lib.optionalString (!buildDocs) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(doc)" ""
  ''
  + lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '';

  # Unfortunately, it seems like we have to call make on this manually
  preInstall = lib.optionalString buildDocs ''
    make -j$NIX_BUILD_CORES doc
    cd ../doc/pdf
    make -j$NIX_BUILD_CORES
    cd -
  '';

  postInstall =
    lib.optionalString buildDocs ''
      mv ../doc/html $out/share/doc/migraphx
      mv ../doc/pdf/MIGraphX.pdf $out/share/doc/migraphx
    ''
    + lib.optionalString buildTests ''
      mkdir -p $test/bin
      mv bin/test_* $test/bin
      patchelf $test/bin/test_* --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE"
    '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = {
    description = "AMD's graph optimization engine";
    homepage = "https://github.com/ROCm/AMDMIGraphX";
    license = with lib.licenses; [ mit ];
    teams = [ lib.teams.rocm ];
    platforms = lib.platforms.linux;
  };
})
