{stdenv, fetchurl, x11, mesa, pkgconfig, imagemagick, libtiff, bzip2}:

stdenv.mkDerivation {
  name = "rss-glx-0.8.1";
  
  src = fetchurl {
    url = mirror://sourceforge/rss-glx/rss-glx_0.8.1.tar.bz2;
    sha256 = "1fs2xavyf9i6vcdmdnpyi9rbnrg05ldd49bvlcwpn5igv2g400yg";
  };

  buildInputs = [x11 mesa pkgconfig imagemagick libtiff bzip2];

  NIX_CFLAGS_COMPILE = "-I${imagemagick}/include/ImageMagick";
}
