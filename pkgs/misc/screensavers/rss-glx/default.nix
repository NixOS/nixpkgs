{stdenv, fetchurl, pkgconfig, x11, libXext, mesa, imagemagick, libtiff, bzip2}:

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "rss-glx-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/rss-glx/rss-glx_${version}.tar.bz2";
    sha256 = "1aikafjqrfmv23jnrrm5d56dg6injh4l67zjdxzdapv9chw7g3cg";
  };

  buildInputs = [ pkgconfig mesa x11 imagemagick libtiff bzip2 ];

  NIX_CFLAGS_COMPILE = "-I${imagemagick}/include/ImageMagick";
  NIX_LDFLAGS= "-rpath ${libXext}/lib";

  meta = {
    description = "Really Slick Screensavers Port to GLX";
    longDescription = ''
      This package currently contains all of the screensavers from the
      original collection, plus a few others.
    '';
    licence = stdenv.lib.licenses.gpl2;
  };
}
