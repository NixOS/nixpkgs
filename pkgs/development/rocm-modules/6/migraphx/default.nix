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
  msgpack,
  sqlite,
  oneDNN,
  blaze,
  texliveSmall,
  doxygen,
  sphinx,
  docutils,
  ghostscript,
  python3Packages,
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
  oneDNN' = oneDNN.overrideAttrs rec {
    version = "2.7.5";
    src = fetchFromGitHub {
      owner = "oneapi-src";
      repo = "oneDNN";
      tag = "v${version}";
      hash = "sha256-oMPBORAdL2rk2ewyUrInYVHYBRvuvNX4p4rwykO3Rhs=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "migraphx";
  version = "6.3.3";

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
    hash = "sha256-h9cTbrMwHeRGVJS/uHQnCXplNcrBqxbhwz2AcAEso0M=";
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
    msgpack
    sqlite
    oneDNN'
    blaze
    python3Packages.pybind11
    python3Packages.onnx
  ];

  LDFLAGS = "-Wl,--allow-shlib-undefined";

  cmakeFlags = [
    "-DMIGRAPHX_ENABLE_GPU=ON"
    "-DMIGRAPHX_ENABLE_CPU=ON"
    "-DMIGRAPHX_ENABLE_FPGA=ON"
    "-DMIGRAPHX_ENABLE_MLIR=OFF" # LLVM or rocMLIR mismatch?
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
    "-DOpenMP_C_INCLUDE_DIR=${openmp.dev}/include"
    "-DOpenMP_CXX_INCLUDE_DIR=${openmp.dev}/include"
    "-DOpenMP_omp_LIBRARY=${openmp}/lib"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  postPatch = ''
    export CXXFLAGS+=" -w -isystem${rocmlir}/include/rocmlir -I${half}/include -I${abseil-cpp}/include -I${hipblas-common}/include"
    patchShebangs tools

    # `error: '__clang_hip_runtime_wrapper.h' file not found [clang-diagnostic-error]`
    substituteInPlace CMakeLists.txt \
      --replace "set(MIGRAPHX_TIDY_ERRORS ALL)" ""
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
    export HOME=$(mktemp -d)
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

  meta = with lib; {
    description = "AMD's graph optimization engine";
    homepage = "https://github.com/ROCm/AMDMIGraphX";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
