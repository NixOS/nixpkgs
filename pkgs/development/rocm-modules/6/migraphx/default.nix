{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  pkg-config,
  cmake,
  rocm-cmake,
  clr,
  clang-tools-extra,
  openmp,
  rocblas,
  rocmlir,
  composable_kernel,
  miopen,
  protobuf,
  half,
  nlohmann_json,
  msgpack,
  sqlite,
  oneDNN_2,
  blaze,
  cppcheck,
  rocm-device-libs,
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "migraphx";
  version = "6.0.2";

  outputs =
    [
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
    hash = "sha256-VDYUSpWYAdJ63SKVCO26DVAC3RtZM7otqN0sYUA6DBQ=";
  };

  nativeBuildInputs =
    [
      pkg-config
      cmake
      rocm-cmake
      clr
      clang-tools-extra
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
    rocmlir
    composable_kernel
    miopen
    protobuf
    half
    nlohmann_json
    msgpack
    sqlite
    oneDNN_2
    blaze
    cppcheck
    python3Packages.pybind11
    python3Packages.onnx
  ];

  cmakeFlags = [
    "-DMIGRAPHX_ENABLE_GPU=ON"
    "-DMIGRAPHX_ENABLE_CPU=ON"
    "-DMIGRAPHX_ENABLE_FPGA=ON"
    "-DMIGRAPHX_ENABLE_MLIR=OFF" # LLVM or rocMLIR mismatch?
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ];

  postPatch =
    ''
      # We need to not use hipcc and define the CXXFLAGS manually due to `undefined hidden symbol: tensorflow:: ...`
      export CXXFLAGS+="--rocm-path=${clr} --rocm-device-lib-path=${rocm-device-libs}/amdgcn/bitcode"
      patchShebangs tools

      # `error: '__clang_hip_runtime_wrapper.h' file not found [clang-diagnostic-error]`
      substituteInPlace CMakeLists.txt \
        --replace "set(MIGRAPHX_TIDY_ERRORS ALL)" ""

      # JIT library was removed from composable_kernel...
      # https://github.com/ROCm/composable_kernel/issues/782
      substituteInPlace src/targets/gpu/CMakeLists.txt \
        --replace " COMPONENTS jit_library" "" \
        --replace " composable_kernel::jit_library" "" \
        --replace "if(WIN32)" "if(TRUE)"
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
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "AMD's graph optimization engine";
    homepage = "https://github.com/ROCm/AMDMIGraphX";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = true;
  };
})
