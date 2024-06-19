{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, git
, rocm-comgr
, rocm-runtime
, hwdata
, texliveSmall
, doxygen
, graphviz
, buildDocs ? true
}:

let
  latex = lib.optionalAttrs buildDocs (texliveSmall.withPackages (ps: with ps; [
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
  ]));
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocdbgapi";
  version = "6.0.2";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "ROCm";
    repo = "ROCdbgapi";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-+CxaTmxRt/RicqQddqIEHs8vvAPCMKXkWg7kbZvnUsQ=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    git
  ] ++ lib.optionals buildDocs [
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
    export HOME=$(mktemp -d)
    make -j$NIX_BUILD_CORES doc
  '';

  postInstall = ''
    substituteInPlace $out/lib/cmake/amd-dbgapi/amd-dbgapi-config.cmake \
      --replace "/build/source/build/" ""

    substituteInPlace $out/lib/cmake/amd-dbgapi/amd-dbgapi-targets.cmake \
      --replace "/build/source/build" "$out"
  '' + lib.optionalString buildDocs ''
    mv $out/share/html/amd-dbgapi $doc/share/doc/amd-dbgapi/html
    rmdir $out/share/html
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Debugger support for control of execution and inspection state";
    homepage = "https://github.com/ROCm/ROCdbgapi";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version || versionAtLeast finalAttrs.version "7.0.0";
  };
})
