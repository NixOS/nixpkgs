{
  lib,
  fetchgit,
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
  version = "6.10.0";

  src = fetchgit {
    url = "https://code.qt.io/pyside/pyside-setup.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zJV4rrqr2bzWFEG1CWOI+y6wbfQDvWAst6T3aSssj6M=";
  };

  sourceRoot = "${finalAttrs.src.name}/sources/shiboken6";

  patches = [ ./fix-include-qt-headers.patch ];

  nativeBuildInputs = [
    cmake
    (python.pythonOnBuildForHost.withPackages (ps: [ ps.setuptools ]))
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    python.pkgs.qt6.qtbase
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    python.pkgs.qt6.darwinVersionInputs
  ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  # We intentionally use single quotes around `${BASH}` since it expands from a CMake
  # variable available in this file.
  postPatch = ''
    substituteInPlace cmake/ShibokenHelpers.cmake --replace-fail '#!/bin/bash' '#!''${BASH}'

    # raise ValueError('ZIP does not support timestamps before 1980')
    find \
      shibokenmodule/files.dir/shibokensupport/ \
      libshiboken/embed/signature_bootstrap.py \
      -exec touch -d "1980-01-01T00:00Z" {} \;
  '';

  postInstall = ''
    cd ../../..
    chmod +w .
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
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
