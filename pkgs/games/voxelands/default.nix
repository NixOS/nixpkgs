{ stdenv, fetchurl, cmake, irrlicht, libpng, bzip2, sqlite
, libjpeg, libXxf86vm, mesa, openal, libvorbis, xlibsWrapper, pkgconfig }:

stdenv.mkDerivation rec {
  name = "voxelands-${version}";
  version = "1506.00";

  src = fetchurl {
      url = "http://voxelands.com/downloads/${name}-src.tar.bz2";
      sha256 = "0j82zidxv2rzx7fmw5z27nfldqkixbrs1f6l3fs433xr3d05406y";
  };

  cmakeFlags = [
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
    "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG"
    "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG"
  ];

  buildInputs = [
    cmake irrlicht libpng bzip2 libjpeg sqlite
    libXxf86vm mesa openal libvorbis xlibsWrapper pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = http://voxelands.com/;
    description = "Infinite-world block sandbox game based on Minetest";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds c0dehero ];
  };
}
