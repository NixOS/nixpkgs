{ stdenv, fetchurl, pkgconfig, glib, libxml2, expat,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  ApplicationServices,
  python27, libpng ? null
}:

stdenv.mkDerivation rec {
  name = "vips-${version}";
  version = "8.7.0";

  src = fetchurl {
    url = "https://github.com/jcupitt/libvips/releases/download/v${version}/${name}.tar.gz";
    sha256 = "16086hdg6m44llz69fkp1n0ckjb7zhl6i2bg0wwllrchznikwiy4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxml2 fftw orc lcms
    imagemagick openexr libtiff libjpeg
    libgsf libexif python27 libpng expat ]
    ++ stdenv.lib.optional stdenv.isDarwin ApplicationServices;

  meta = with stdenv.lib; {
    homepage = http://www.vips.ecs.soton.ac.uk;
    description = "Image processing system for large images";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ kovirobi ];
    platforms = platforms.unix;
  };
}
