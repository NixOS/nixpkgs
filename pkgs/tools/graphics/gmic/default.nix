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
  version = "2.9.1";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "13axx7nwchn6ysgpvlw3fib474q4nrwv3qn20g3q03ldid0xvjah";
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
