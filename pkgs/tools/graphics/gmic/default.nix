{ stdenv
, fetchurl
, cmake
, ninja
, pkg-config
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
  version = "2.9.4";

  outputs = [ "out" "lib" "dev" "man" ];

  src = fetchurl {
    url = "https://gmic.eu/files/source/gmic_${version}.tar.gz";
    sha256 = "1ixcdq16gmgh1brrb6mgdibypq9lvh8gnz86b5mmyxlnyi4fw2vr";
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
    opencv
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
