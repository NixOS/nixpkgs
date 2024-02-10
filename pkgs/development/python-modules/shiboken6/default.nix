{ lib
, fetchurl
, fetchpatch
, llvmPackages
, python
, cmake
, autoPatchelfHook
, stdenv
}:

let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation rec {
  pname = "shiboken6";
  version = "6.6.0";

  src = fetchurl {
    # https://download.qt.io/official_releases/QtForPython/shiboken6/
    url = "https://download.qt.io/official_releases/QtForPython/shiboken6/PySide6-${version}-src/pyside-setup-everywhere-src-${version}.tar.xz";
    sha256 = "sha256-LdAC24hRqHFzNU84qoxuxC0P8frJnqQisp4t/OUtFjg=";
  };

  sourceRoot = "pyside-setup-everywhere-src-${lib.removeSuffix ".0" version}/sources/${pname}";

  patches = [
    ./fix-include-qt-headers.patch
    # TODO: remove after bumping above 6.6.0
    (fetchpatch {
      name = "shiboken6-improve-api-extractor-argument-parsing.patch";
      url = "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/?id=6abde77c3df60ccac25089660df5797de7f6e68c";
      hash = "sha256-uctp5rjY16X37BYzsZzg9AAgM2hwNVkcNxT1bCobb0I=";
      stripLen = 2;
    })
  ];

  nativeBuildInputs = [
    cmake
    (python.pythonOnBuildForHost.withPackages (ps: [ ps.setuptools ]))
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    python.pkgs.qt6.qtbase
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  # We intentionally use single quotes around `${BASH}` since it expands from a CMake
  # variable available in this file.
  postPatch = ''
    substituteInPlace cmake/ShibokenHelpers.cmake --replace '#!/bin/bash' '#!''${BASH}'
  '';

  # Due to Shiboken.abi3.so being linked to libshiboken6.abi3.so.6.6 in the build tree,
  # we need to remove the build tree reference from the RPATH and then add the correct
  # directory to the RPATH. On Linux, the second part is handled by autoPatchelfHook.
  # https://bugreports.qt.io/browse/PYSIDE-2233
  preFixup = ''
    echo "fixing RPATH of Shiboken.abi3.so"
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -change {@rpath,$out/lib}/libshiboken6.abi3.6.6.dylib $out/${python.sitePackages}/shiboken6/Shiboken.abi3.so
  '' + lib.optionalString stdenv.isLinux ''
    patchelf $out/${python.sitePackages}/shiboken6/Shiboken.abi3.so --shrink-rpath --allowed-rpath-prefixes ${builtins.storeDir}
  '';

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=shiboken6
    cp -r shiboken6.egg-info $out/${python.sitePackages}/
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Generator for the pyside6 Qt bindings";
    license = with licenses; [ lgpl3Only gpl2Only gpl3Only ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner Enzime ];
    platforms = platforms.all;
  };
}
