{ stdenv
, fetchurl
, cmake
, ninja
, pkgconfig
, opencv
, openexr
, graphicsmagick
, fftw
, zlib
, libjpeg
, libtiff
, libpng
}:

stdenv.mkDerivation rec {
  pname = "gmic";
  version = "2.7.1";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "1sxgmrxv1px07h5m7dcdg24c6x39ifjbc1fmz8p2ah91pm57h7n7";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkgconfig
  ];

  buildInputs = [
    fftw
    zlib
    libjpeg
    libtiff
    libpng
    opencv
    openexr
    graphicsmagick
  ];

  cmakeFlags = [
    "-DBUILD_LIB_STATIC=OFF"
    "-DENABLE_DYNAMIC_LINKING=ON"
  ];

  meta = with stdenv.lib; {
    description = "Open and full-featured framework for image processing";
    homepage = http://gmic.eu/;
    license = licenses.cecill20;
    platforms = platforms.unix;
  };
}
