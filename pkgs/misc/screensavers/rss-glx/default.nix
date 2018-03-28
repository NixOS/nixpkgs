{stdenv, fetchurl, pkgconfig, xlibsWrapper, libXext, libGLU_combined, imagemagick, libtiff, bzip2}:

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "rss-glx-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/rss-glx/rss-glx_${version}.tar.bz2";
    sha256 = "1aikafjqrfmv23jnrrm5d56dg6injh4l67zjdxzdapv9chw7g3cg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libGLU_combined xlibsWrapper imagemagick libtiff bzip2 ];

  NIX_CFLAGS_COMPILE = "-I${imagemagick.dev}/include/ImageMagick";
  NIX_LDFLAGS= "-rpath ${libXext}/lib";

  meta = {
    description = "Really Slick Screensavers Port to GLX";
    longDescription = ''
      This package currently contains all of the screensavers from the
      original collection, plus a few others.
    '';
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
