{ stdenv, fetchurl, pkgconfig, glib, libxml2, flex, bison, vips, expat,
  fftw, orc, lcms, imagemagick, openexr, libtiff, libjpeg, libgsf, libexif,
  python27, libpng, matio ? null, cfitsio ? null, libwebp ? null
}:

stdenv.mkDerivation rec {
  name = "vips-${version}";
  version = "8.6.4";

  src = fetchurl {
    url = "https://github.com/jcupitt/libvips/releases/download/v${version}/${name}.tar.gz";
    sha256 = "1x4ai997yfl4155r4k3m5fa5hj3030c4abi5g49kfarbr60a0ca6";
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
