{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, expat,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  python27, libpng, matio ? null, cfitsio ? null, libwebp ? null
}:

stdenv.mkDerivation rec {
  name = "vips-${version}";
  version = "8.6.3";

  src = fetchurl {
    url = "https://github.com/jcupitt/libvips/releases/download/v${version}/${name}.tar.gz";
    sha256 = "14h9w61gaimldmqaym0zhf9fkxjj1pkd5lhglhs6pxphynwxnnpq";
  };

  buildInputs =
    [ pkgconfig glib libxml2 fftw orc lcms
      imagemagick openexr libtiff libjpeg
      libgsf libexif python27 libpng
      expat
    ];

  meta = with stdenv.lib; {
    homepage = http://www.vips.ecs.soton.ac.uk;
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.linux;
  };
}
