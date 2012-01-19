{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "wkhtmltopdf-0.11.0_rc1";

  src = fetchurl {
    url = "http://wkhtmltopdf.googlecode.com/files/${name}.tar.bz2";
    sha1 = "db03922d281856e503b3d562614e3936285728c7";
  };

  buildInputs = [ qt4 ];

  configurePhase = "qmake wkhtmltopdf.pro INSTALLBASE=$out";
  
  enableParallelBuilding = true;

  meta = {
    homepage = http://code.google.com/p/wkhtmltopdf/;
    description = "Tools for rendering web pages to PDF or images";
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
