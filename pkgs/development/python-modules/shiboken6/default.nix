{
  python,
  fetchurl,
  lib,
  pyside6,
  cmake,
  qt6,
  llvmPackages_13,
}: let
  llvmPackages = llvmPackages_13;
  stdenv = llvmPackages.stdenv;
in
  stdenv.mkDerivation rec {
    pname = "shiboken6";

    inherit (pyside6) version src;

    patches = [
      ./nix_compile_cflags.patch
    ];

    preBuild = ''
      cd sources/${pname}
    '';

    CLANG_INSTALL_DIR = llvmPackages.libclang.lib;

    nativeBuildInputs = [cmake python];

    buildInputs =
      (with python.pkgs; [
        packaging
        setuptools
        wheel
        # sphinx # uncomment to build docs
      ])
      ++ [
        python
        llvmPackages.libclang
        llvmPackages.libllvm
        qt6.qtbase
      ];

    cmakeFlags = [
      "-DBUILD_TESTS=OFF"
      "-DNUMPY_INCLUDE_DIR=${python.pkgs.numpy}/${python.sitePackages}/numpy/core/include"
    ];

    #QT_LOGGING_RULES = "*.debug=true"; # debug

    dontWrapQtApps = true;

    postInstall = ''
      rm $out/bin/shiboken_tool.py
      cd ../../..
      python setup.py egg_info --build-type=shiboken6
      cp -r shiboken6.egg-info $out/${python.sitePackages}/
    '';

    # CMake Error at /nix/store/hci18lwgg9lfdh5fz1rhkf24jdkrky06-shiboken6-6.2.2-dev/lib/cmake/Shiboken6-6.2.2/Shiboken6Targets.cmake:82 (message):
    #   The imported target "Shiboken6::libshiboken" references the file
    #      "/nix/store/hci18lwgg9lfdh5fz1rhkf24jdkrky06-shiboken6-6.2.2-dev/lib/libshiboken6.cpython-39-x86_64-linux-gnu.so.6.2.2"
    #   but this file does not exist.  Possible reasons include:
    #outputs = [ "out" "dev"];

    meta = with lib; {
      description = "Generator for the pyside6 Qt bindings";
      license = with licenses; [gpl2 lgpl21];
      homepage = "https://wiki.qt.io/Qt_for_Python";
      maintainers = with maintainers; [];
      broken = stdenv.isDarwin;
    };
  }
