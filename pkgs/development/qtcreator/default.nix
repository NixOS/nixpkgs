{ stdenv, fetchurl, qt48 }:

let
  baseVersion = "2.8";
  revision = "0";
  version = "${baseVersion}.${revision}";
  qt4_for_qtcreator = qt48.override {
    developerBuild = true;
  };
in

stdenv.mkDerivation rec {
  name = "qtcreator-${version}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qtcreator/${baseVersion}/${version}/qt-creator-${version}-src.tar.gz";
    sha256 = "7ac5d9a36c2f561f74d77378d4eae95a78c7752b323e1df924d6e895e99f45d2";
  };

  buildInputs = [ qt4_for_qtcreator ];

  doCheck = false;

  enableParallelBuilding = true;

  preConfigure = ''
    qmake -spec linux-g++ "QT_PRIVATE_HEADERS=${qt4_for_qtcreator}/include" qtcreator.pro
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
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.all;
  };
}
