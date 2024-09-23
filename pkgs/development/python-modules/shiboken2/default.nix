{
  python,
  pythonAtLeast,
  lib,
  stdenv,
  pyside2,
  cmake,
  qt5,
  libxcrypt,
  llvmPackages_15,
}:

stdenv.mkDerivation {
  pname = "shiboken2";

  inherit (pyside2) version src patches;

  postPatch =
    (lib.optionalString (pythonAtLeast "3.12") ''
      substituteInPlace \
        ez_setup.py \
        build_scripts/main.py \
        build_scripts/options.py \
        build_scripts/utils.py \
        build_scripts/wheel_override.py \
        build_scripts/wheel_utils.py \
        sources/shiboken2/CMakeLists.txt \
        sources/shiboken2/data/shiboken_helpers.cmake \
        --replace-fail "from distutils" "import setuptools; from distutils"
      substituteInPlace \
        build_scripts/config.py \
        build_scripts/main.py \
        build_scripts/options.py \
        build_scripts/setup_runner.py \
        build_scripts/utils.py \
        --replace-fail "import distutils" "import setuptools; import distutils"
    '')
    + ''
      cd sources/shiboken2
    '';

  CLANG_INSTALL_DIR = llvmPackages_15.libclang.out;

  nativeBuildInputs = [
    cmake
    (python.withPackages (ps: with ps; [ setuptools ]))
  ];

  buildInputs =
    [
      llvmPackages_15.libclang
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
    maintainers = with maintainers; [ gebner ];
  };
}
