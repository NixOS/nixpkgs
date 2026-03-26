{
  lib,
  fetchgit,
  llvmPackages,
  python,
  cmake,
  stdenv,
}:

let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "shiboken6-generator";
  version = "6.11.0";

  src = fetchgit {
    url = "https://code.qt.io/pyside/pyside-setup.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UbvH+wNiXjfMhaRUODx3p2cJmAz/dJ5kjPSprGKwsYg=";
  };

  patches = [
    ./fix-include-qt-headers.patch
  ];

  sourceRoot = "${finalAttrs.src.name}/sources/shiboken6_generator";

  nativeBuildInputs = [
    cmake
    python.pkgs.ninja
    (python.withPackages (ps: [
      ps.packaging
      ps.setuptools
    ]))
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libclang
    python.pkgs.qt6.qtbase
  ];

  cmakeFlags = [
    "-Dis_pyside6_superproject_build=1"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    chmod +w .
    python3 setup.py egg_info --build-type=shiboken6-generator
    cp -r shiboken6_generator.egg-info $out/${python.sitePackages}/
  '';

  meta = {
    description = "Generator for the pyside6 Qt bindings - tools";
    license = with lib.licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    changelog = "https://code.qt.io/cgit/pyside/pyside-setup.git/tree/doc/changelogs/changes-${finalAttrs.version}?h=v${finalAttrs.version}";
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "shiboken6";
  };
})
