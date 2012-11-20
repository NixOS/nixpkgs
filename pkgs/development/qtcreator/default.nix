{ stdenv, fetchurl, qt4 }:

let
  version = "2.5.2";
in

stdenv.mkDerivation rec {
  name = "qtcreator-${version}";

  src = fetchurl {
    url = "http://origin.releases.qt-project.org/qtcreator/${version}/qt-creator-${version}-src.tar.gz";
    md5 = "4a9c09cdf4609753283c31451c84ceb8";
  };

  buildInputs = [ qt4 ];

  doCheck = false;

  enableParallelBuilding = true;

  preConfigure = "qmake";
  installFlags = "INSTALL_ROOT=$(out)";

  meta = {
    description = "Qt Creator is a cross-platform IDE tailored to the needs of Qt developers.";
    longDescription = ''
        Qt Creator is a cross-platform IDE (integrated development environment) tailored to the needs of Qt developers.
        It includes features such as an advanced code editor, a visual debugger and a GUI designer.
      '';
    homepage = "http://qt-project.org/wiki/Category:Tools::QtCreator";
    license = "LGPL";

    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.all;
  };
}
