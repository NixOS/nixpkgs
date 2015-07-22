{ stdenv, fetchurl, pkgconfig, cairo, gtk, poppler }:

stdenv.mkDerivation {
  name = "pdf2svg-0.2.2";

  src = fetchurl {
    url = "http://www.cityinthesky.co.uk/wp-content/uploads/2013/10/pdf2svg-0.2.2.tar.gz" ; 
    sha256 = "1jy6iqwwvd7drcybmdlmnc8m970f82fd7fisa8ha5zh13p49r8n2";
  };

  buildInputs = [ cairo pkgconfig poppler gtk ];

  meta = { 
    description = "PDF converter to SVG format";
    homepage = http://www.cityinthesky.co.uk/opensource/pdf2svg;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.ianwookim ];
    platforms = stdenv.lib.platforms.unix;
  };
}
