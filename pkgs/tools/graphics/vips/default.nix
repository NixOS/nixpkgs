{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, gnome,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  python27, libpng, matio ? null, cfitsio ? null, libwebp ? null
}:

stdenv.mkDerivation rec {
  name = "vips-8.3.1";

  src = fetchurl {
    url = "http://www.vips.ecs.soton.ac.uk/supported/current/${name}.tar.gz";
    sha256 = "01hh1baar2r474kny24fcq6ddshcvq104207mqxnkis0as6pzjq9";
  };

  buildInputs =
    [ pkgconfig glib libxml2 fftw orc lcms
      imagemagick openexr libtiff libjpeg
      libgsf libexif python27 libpng
    ];

  meta = with stdenv.lib; {
    homepage = http://www.vips.ecs.soton.ac.uk;
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.linux;
  };
}
