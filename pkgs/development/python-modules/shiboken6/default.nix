{
  lib,
  fetchurl,
  llvmPackages,
  python,
  cmake,
  autoPatchelfHook,
  stdenv,
}:

let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "shiboken6";
  version = "6.7.2";

  src = fetchurl {
    # https://download.qt.io/official_releases/QtForPython/shiboken6/
    url = "mirror://qt/official_releases/QtForPython/shiboken6/PySide6-${finalAttrs.version}-src/pyside-setup-everywhere-src-${finalAttrs.version}.tar.xz";
    hash = "sha256-OisNDW54yapd3H8GyktvEaP+FFYLrrFI7qU7XZjjaMc=";
  };

  sourceRoot = "pyside-setup-everywhere-src-${finalAttrs.version}/sources/shiboken6";

  patches = [ ./fix-include-qt-headers.patch ];

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

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=shiboken6
    cp -r shiboken6.egg-info $out/${python.sitePackages}/
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Generator for the pyside6 Qt bindings";
    license = with lib.licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    changelog = "https://code.qt.io/cgit/pyside/pyside-setup.git/tree/doc/changelogs/changes-${finalAttrs.version}?h=v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ gebner ];
    platforms = lib.platforms.all;
  };
})
