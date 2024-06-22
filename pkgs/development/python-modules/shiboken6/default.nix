{
  lib,
  fetchurl,
  fetchpatch,
  llvmPackages,
  python,
  cmake,
  autoPatchelfHook,
  stdenv,
}:

let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation rec {
  pname = "shiboken6";
  version = "6.7.0";

  src = fetchurl {
    # https://download.qt.io/official_releases/QtForPython/shiboken6/
    url = "https://download.qt.io/official_releases/QtForPython/shiboken6/PySide6-${version}-src/pyside-setup-everywhere-src-${version}.tar.xz";
    hash = "sha256-gurjcHN99ez1OcFl0J18gdX8YVOlQbjT03sRJ1+ePo8=";
  };

  sourceRoot = "pyside-setup-everywhere-src-${version}/sources/${pname}";

  patches = [
    ./fix-include-qt-headers.patch
    # Remove this patch when updating to 6.8.0
    (fetchpatch {
      name = "backwards-compatibility-with-6.6.x.patch";
      url = "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/?id=4f9a20e3635f4f0957e0774588b1d9156e88a572";
      hash = "sha256-B2jhLWopgaSF/rUXMZFPZArDUNojlBgn7kdVyQull+I=";
      stripLen = 2;
    })
  ];

  nativeBuildInputs = [
    cmake
    (python.pythonOnBuildForHost.withPackages (ps: [ ps.setuptools ]))
  ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    python.pkgs.qt6.qtbase
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
  ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  # We intentionally use single quotes around `${BASH}` since it expands from a CMake
  # variable available in this file.
  postPatch = ''
    substituteInPlace cmake/ShibokenHelpers.cmake --replace-fail '#!/bin/bash' '#!''${BASH}'
  '';

  # Due to Shiboken.abi3.so being linked to libshiboken6.abi3.so.6.6 in the build tree,
  # we need to remove the build tree reference from the RPATH and then add the correct
  # directory to the RPATH. On Linux, the second part is handled by autoPatchelfHook.
  # https://bugreports.qt.io/browse/PYSIDE-2233
  preFixup =
    ''
      echo "fixing RPATH of Shiboken.abi3.so"
    ''
    + lib.optionalString stdenv.isDarwin ''
      install_name_tool -change {@rpath,$out/lib}/libshiboken6.abi3.6.6.dylib $out/${python.sitePackages}/shiboken6/Shiboken.abi3.so
    ''
    + lib.optionalString stdenv.isLinux ''
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
    license = with licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [
      gebner
      Enzime
    ];
    platforms = platforms.all;
  };
}
