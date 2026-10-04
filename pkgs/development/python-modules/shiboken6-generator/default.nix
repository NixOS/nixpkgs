{
  lib,
  fetchgit,
  llvmPackages,
  python,
  cmake,
  stdenv,
  makeShellWrapper,
}:

let
  stdenv' = if stdenv.cc.isClang then stdenv else llvmPackages.stdenv;
in
stdenv'.mkDerivation (finalAttrs: {
  pname = "shiboken6-generator";
  version = "6.12.0-pre";

  src = fetchgit {
    url = "https://code.qt.io/pyside/pyside-setup.git";
    rev = "25c0be13581177205fa64d4941aa4b25b2a5e6fd";
    hash = "sha256-CMlTzQKkeys4mYJEVFp6aH79zlVEl9Gw+gf1cdo/yQ0=";
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
    makeShellWrapper
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

  postFixup = ''
    wrapProgramShell $out/bin/shiboken6 --add-flags '--typesystem-paths=$NIXPKGS_SHIBOKEN6_TYPESYSTEMS_PATH'
  '';

  setupHook = ./shiboken6-hook.sh;

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
