{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, clr
, clblast
, texliveSmall
, doxygen
, sphinx
, openblas
, python3Packages
, buildDocs ? true
, buildTests ? false
, buildBenchmarks ? false
}:

let
  latex = lib.optionalAttrs buildDocs (texliveSmall.withPackages (ps: with ps; [
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
  ]));
in stdenv.mkDerivation (finalAttrs: {
  pname = "miopengemm";
  version = "5.5.0";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  # Deprecated? https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/issues/62
  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "MIOpenGEMM";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-AiRzOMYRA/0nbQomyq4oOEwNZdkPYWRA2W6QFlctvFc=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clr
  ];

  buildInputs = lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
  ] ++ lib.optionals buildTests [
    openblas
  ] ++ lib.optionals buildBenchmarks [
    clblast
    python3Packages.triton
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DOPENBLAS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DAPI_BENCH_MIOGEMM=ON"
    "-DAPI_BENCH_CLBLAST=ON"
    "-DAPI_BENCH_ISAAC=ON"
  ];

  # Unfortunately, it seems like we have to call make on these manually
  postBuild = lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    make doc
  '' + lib.optionalString buildTests ''
    make check
  '' + lib.optionalString buildBenchmarks ''
    make examples
  '';

  postInstall = lib.optionalString buildDocs ''
    mv ../doc/html $out/share/doc/miopengemm
    mv ../doc/pdf/miopengemm.pdf $out/share/doc/miopengemm
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    find tests -executable -type f -exec mv {} $test/bin \;
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib $test/bin/*
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    find examples -executable -type f -exec mv {} $benchmark/bin \;
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib $benchmark/bin/*
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "OpenCL general matrix multiplication API for ROCm";
    homepage = "https://github.com/ROCmSoftwarePlatform/MIOpenGEMM";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    # They are not making tags or releases, this may break other derivations in the future
    # Use version major instead of minor, 6.0 will HOPEFULLY have a release or tag
    broken = versions.major finalAttrs.version != versions.major stdenv.cc.version || versionAtLeast finalAttrs.version "6.0.0";
  };
})
