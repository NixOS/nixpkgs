{stdenv, fetchurl, x11, mesa, pkgconfig, imagemagick, libtiff, bzip2}:

stdenv.mkDerivation {
  name = "rss-glx-0.8.1";
  
  src = fetchurl {
    url = mirror://sourceforge/rss-glx/rss-glx_0.8.1.tar.bz2;
    md5 = "a2bdf0e10ee4e89c8975f313c5c0ba6f";
  };

  buildInputs = [x11 mesa pkgconfig imagemagick libtiff bzip2];

  NIX_CFLAGS_COMPILE = "-I${imagemagick}/include/ImageMagick";
}
