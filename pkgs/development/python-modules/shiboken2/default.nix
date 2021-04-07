{ buildPythonPackage, python, fetchurl, lib, stdenv, pyside2
, cmake, qt5, llvmPackages }:

stdenv.mkDerivation {
  pname = "shiboken2";

  inherit (pyside2) version src;

  patches = [
    ./nix_compile_cflags.patch
  ];

  postPatch = ''
    cd sources/shiboken2
  '';

  CLANG_INSTALL_DIR = llvmPackages.libclang.out;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ llvmPackages.libclang python qt5.qtbase qt5.qtxmlpatterns ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    rm $out/bin/shiboken_tool.py
  '';

  meta = with lib; {
    description = "Generator for the PySide2 Qt bindings";
    license = with licenses; [ gpl2 lgpl21 ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
    broken = stdenv.isDarwin;
  };
}
