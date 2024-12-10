{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  pkg-config,
  libX11,
  libXext,
  libGLU,
  libGL,
  imagemagick6,
  libtiff,
  bzip2,
}:

stdenv.mkDerivation rec {
  version = "0.9.1";
  pname = "rss-glx";

  src = fetchurl {
    url = "mirror://sourceforge/rss-glx/rss-glx_${version}.tar.bz2";
    sha256 = "1aikafjqrfmv23jnrrm5d56dg6injh4l67zjdxzdapv9chw7g3cg";
  };

  nativeBuildInputs = [
    autoconf
    pkg-config
  ];
  buildInputs = [
    libGLU
    libGL
    libX11
    libXext
    imagemagick6
    libtiff
    bzip2
  ];

  patches = [
    ./cstddef.patch
  ];

  env.NIX_CFLAGS_COMPILE = "-I${imagemagick6.dev}/include/ImageMagick";

  meta = {
    description = "Really Slick Screensavers Port to GLX";
    longDescription = ''
      This package currently contains all of the screensavers from the
      original collection, plus a few others.
    '';
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
