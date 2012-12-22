{ stdenv, fetchurl, qt4_for_qtcreator }:

let
  version = "2.6.0";
in

stdenv.mkDerivation rec {
  name = "qtcreator-${version}";

  src = fetchurl {
    url = "http://origin.releases.qt-project.org/qtcreator/${version}/qt-creator-${version}-src.tar.gz";
    md5 = "9bf01098f84a0fe930b2718d11124204";
  };

  buildInputs = [ qt4_for_qtcreator ];

  doCheck = false;

  enableParallelBuilding = true;

  preConfigure = ''
    qmake -spec linux-g++ "QT_PRIVATE_HEADERS=${qt4_for_qtcreator}/include" qtcreator.pro
  '';

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
