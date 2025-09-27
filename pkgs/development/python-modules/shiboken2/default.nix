{
  python,
  lib,
  stdenv,
  pyside2,
  cmake,
  qt5,
  libxcrypt,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "shiboken2";

  inherit (pyside2) version src patches;

  postPatch = ''
    cd sources/shiboken2
  '';

  CLANG_INSTALL_DIR = llvmPackages.libclang.out;

  nativeBuildInputs = [
    cmake
    (python.withPackages (
      ps: with ps; [
        distutils
        setuptools
      ]
    ))
    qt5.qmake
  ];

  buildInputs = [
    llvmPackages.libclang
    python.pkgs.setuptools
    qt5.qtbase
    qt5.qtxmlpatterns
  ]
  ++ (lib.optionals (python.pythonOlder "3.9") [
    # see similar issue: 202262
    # libxcrypt is required for crypt.h for building older python modules
    libxcrypt
  ]);

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=shiboken2
    cp -r shiboken2.egg-info $out/${python.sitePackages}/
    rm $out/bin/shiboken_tool.py
  '';

  meta = with lib; {
    description = "Generator for the PySide2 Qt bindings";
    mainProgram = "shiboken2";
    license = with licenses; [
      gpl2
      lgpl21
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = [ ];
    broken = python.pythonAtLeast "3.13";
  };
}
