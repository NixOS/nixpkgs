{ stdenv
, fetchurl
, cmake
, ninja
, pkg-config
, opencv3
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
  version = "2.9.0";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "YjNpX5snmZ3MfMOqdICw8ZK9RN6FIJCRo7S4plroxLU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fftw
    zlib
    libjpeg
    libtiff
    libpng
    opencv3
    openexr
    graphicsmagick
  ];

  cmakeFlags = [
    "-DBUILD_LIB_STATIC=OFF"
    "-DENABLE_CURL=OFF"
    "-DENABLE_DYNAMIC_LINKING=ON"
  ];

  meta = with stdenv.lib; {
    description = "Open and full-featured framework for image processing";
    homepage = "https://gmic.eu/";
    license = licenses.cecill20;
    platforms = platforms.unix;
  };
}
