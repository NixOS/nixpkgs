{ stdenv, fetchurl, fftw, zlib, libjpeg, libtiff, libpng }:

stdenv.mkDerivation rec {
  name = "gmic-${version}";
  version = "1.6.5.0";

  src = fetchurl {
    url = "http://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "1vb6zm5zpqfnzxjvb9yfvczaqacm55rf010ib0yk9f28b17qrjgb";
  };

  buildInputs = [ fftw zlib libjpeg libtiff libpng ];

  sourceRoot = "${name}/src";

  preBuild = ''
    buildFlagsArray=( \
      CURL_CFLAGS= CURL_LIBS= \
      EXR_CFLAGS= EXR_LIBS= \
      OPENCV_CFLAGS= OPENCV_LIBS= \
      X11_CFLAGS="-Dcimg_display=0" X11_LIBS= \
      cli \
    )
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    cp -v gmic $out/bin/
    cp -v ../man/gmic.1.gz $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "G'MIC is an open and full-featured framework for image processing";
    homepage = http://gmic.eu/;
    license = licenses.cecill20;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.linux;
  };
}
