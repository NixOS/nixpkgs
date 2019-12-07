{ stdenv
, fetchurl
, cmake
, ninja
, pkgconfig
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
  version = "2.7.5";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "008lpjm3w5hzfccam6qf0rizdg3a9cqrizhr7vrpskmbr1j451d6";
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
    opencv3
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
