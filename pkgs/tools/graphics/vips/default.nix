{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, gnome,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  python27, libpng, matio ? null, cfitsio ? null, libwebp ? null
}:

stdenv.mkDerivation rec {
  name = "vips-8.0.2";

  src = fetchurl {
    url = "http://www.vips.ecs.soton.ac.uk/supported/current/${name}.tar.gz";
    sha256 = "0fpshv71sxbkbycxgd2hvwn7fyq9rm0rsgq0b1zld1an88mi0v8y";
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
