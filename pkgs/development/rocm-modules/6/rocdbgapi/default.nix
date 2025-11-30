{
  lib,
  stdenv,
  fetchFromGitHub,
  rocmUpdateScript,
  cmake,
  rocm-cmake,
  rocm-comgr,
  rocm-runtime,
  hwdata,
  texliveSmall,
  doxygen,
  graphviz,
  writableTmpDirAsHomeHook,
  buildDocs ? true,
}:

let
  latex = lib.optionalAttrs buildDocs (
    texliveSmall.withPackages (
      ps: with ps; [
        changepage
        latexmk
        varwidth
        multirow
        hanging
        adjustbox
        collectbox
        stackengine
        enumitem
        alphalph
        wasysym
        sectsty
        tocloft
        newunicodechar
        etoc
        helvetic
        wasy
        courier
        tabularray
        ltablex
        ninecolors
        xltabular
      ]
    )
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rocdbgapi";
  version = "6.4.3";

  outputs = [
    "out"
  ]
  ++ lib.optionals buildDocs [
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCdbgapi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-Rr8+SNeFps0rjk4Jn2+rFmtRJfL42l0tNOz13oZQy+I=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ]
  ++ lib.optionals buildDocs [
    writableTmpDirAsHomeHook
    latex
    doxygen
    graphviz
  ];

  buildInputs = [
    rocm-comgr
    rocm-runtime
    hwdata
  ];

  cmakeFlags = [
    "-DPCI_IDS_PATH=${hwdata}/share/hwdata"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  # Unfortunately, it seems like we have to call make on this manually
  postBuild = lib.optionalString buildDocs ''
    make -j$NIX_BUILD_CORES doc
  '';

  postInstall = lib.optionalString buildDocs ''
    mv $out/share/html/amd-dbgapi $doc/share/doc/amd-dbgapi/html
    rmdir $out/share/html
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    inherit (finalAttrs.src) owner;
    inherit (finalAttrs.src) repo;
  };

  meta = with lib; {
    description = "Debugger support for control of execution and inspection state";
    homepage = "https://github.com/ROCm/ROCdbgapi";
    license = with licenses; [ mit ];
    teams = [ teams.rocm ];
    platforms = platforms.linux;
  };
})
