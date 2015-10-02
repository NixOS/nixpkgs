{ stdenv, fetchurl
, boost, freeglut, glew, gsl, lcms2, libpng, libtiff, libxmi, mesa, vigra
, help2man, pkgconfig, perl }:

let version = "4.1.4"; in
stdenv.mkDerivation rec {
  name = "enblend-enfuse-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/enblend/${name}.tar.gz";
    sha256 = "0208x01i129hqylmy6jh3krwdac47mx6fi8xccjm9h35c18c7xl5";
  };

  buildInputs = [ boost freeglut glew gsl lcms2 libpng libtiff libxmi mesa vigra ];

  nativeBuildInputs = [ help2man perl pkgconfig ];

  enableParallelBuilding = true;

  meta = {
    inherit version;
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = stdenv.lib.licenses.gpl2;
  };
}
