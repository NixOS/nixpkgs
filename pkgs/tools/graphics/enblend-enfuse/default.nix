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

  patches =
    let
      prefix = "http://enblend.hg.sourceforge.net/hgweb/enblend/enblend/raw-diff";
    in map fetchurl [
      {
        url = "${prefix}/9d9b5f3a97cd/src/vigra_impex/png.cxx";
        name = "ftbfs-libpng15.patch";
        sha256 = "1nqhbbgphwi087qpazngg04c1whc1p4fwq19fx36jrir96xywgzg";
      }
      {
        url = "${prefix}/101796703d73/src/vigra_impex/png.cxx";
        name = "ftbfs-libpng15.patch";
        sha256 = "14frqg4hab9ab6pdypkrmji43fmxjj918j7565rdwmifbm9i3005";
      }
    ];

  meta = {
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = "GPLv2";
  };
}
