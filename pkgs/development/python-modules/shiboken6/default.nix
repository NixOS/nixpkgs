{
  lib,
  llvmPackages,
  python,
  shiboken6-generator,
  numpy,
  cmake,
  stdenv,
}:

let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "shiboken6";

  inherit (shiboken6-generator) version src;

  sourceRoot = "${finalAttrs.src.name}/sources/shiboken6";

  nativeBuildInputs = [
    cmake
    python.pkgs.ninja
    (python.pythonOnBuildForHost.withPackages (ps: [
      ps.packaging
      ps.setuptools
    ]))
  ];

  propagatedNativeBuildInputs = [
    shiboken6-generator
  ];

  buildInputs = [
    python.pkgs.qt6.qtbase
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    python.pkgs.qt6.darwinVersionInputs
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DNUMPY_INCLUDE_DIR=${numpy.coreIncludeDir}"
    "-Dis_pyside6_superproject_build=1"
  ];

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
    python3 setup.py egg_info --build-type=shiboken6
    cp -r shiboken6.egg-info $out/${python.sitePackages}/
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Generator for the pyside6 Qt bindings - Python library";
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
