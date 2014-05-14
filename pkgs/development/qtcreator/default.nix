{ stdenv, fetchurl, qtLib, sdkBuild ? false }:

with stdenv.lib;

let
  baseVersion = "3.1";
  revision = "0";
  version = "${baseVersion}.${revision}";
in

stdenv.mkDerivation rec {
  # The package name depends on wether we are just building the QtCreator package or the whole Qt SDK
  # If we are building the QtCreator package: qtcreator-version
  # If we are building the QtSDK package, the Qt version is also included: qtsdk-version-qt-version
  name = "qt${if sdkBuild then "sdk" else "creator"}-${version}"
    + optionalString sdkBuild "-qt-${qtLib.version}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qtcreator/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.gz";
    sha256 = "c8c648f4988b707393e0f1958a8868718f27e59263f05f3b6599fa62290c2bbf";
  };

  # This property can be used in a nix development environment to refer to the Qt package
  # eg: export QTDIR=${qtSDK.qt}
  qt = qtLib;

  # We must only propagate Qt (including qmake) when building the QtSDK
  propagatedBuildInputs = if sdkBuild then [ qtLib ] else [];
  buildInputs = if sdkBuild == false then [ qtLib ] else [];

  doCheck = false;

  enableParallelBuilding = true;

  preConfigure = ''
    qmake -spec linux-g++ "QT_PRIVATE_HEADERS=${qtLib}/include" qtcreator.pro
  '';

  installFlags = "INSTALL_ROOT=$(out)";

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "http://qt-project.org/wiki/Category:Tools::QtCreator";
    license = "LGPL";
    maintainers = [ maintainers.bbenoist ];
    platforms = platforms.all;
  };
}
