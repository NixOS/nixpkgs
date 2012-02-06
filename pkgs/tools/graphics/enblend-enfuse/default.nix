{stdenv, fetchurl, libtiff, libpng, lcms, libxmi, boost, mesa, freeglut
, pkgconfig, perl, glew }:

stdenv.mkDerivation rec {
  name = "enblend-enfuse-4.0";

  src = fetchurl {
    url = "mirror://sourceforge/enblend/${name}.tar.gz";
    sha256 = "1i2kq842zrncpadarhcikg447abmh5r7a5js3mzg553ql3148am1";
  };

  buildInputs = [ libtiff libpng lcms libxmi boost mesa freeglut glew ];

  buildNativeInputs = [ perl pkgconfig ];

  meta = {
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = "GPLv2";
  };
}
