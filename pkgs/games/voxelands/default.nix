{ stdenv, fetchurl, cmake, irrlicht, libpng, bzip2, sqlite
, libjpeg, libXxf86vm, mesa, openal, libvorbis, x11, pkgconfig }:

stdenv.mkDerivation rec {
  name = "voxelands-${version}";
  version = "1504.01";

  src = fetchurl {
      url = "http://voxelands.com/downloads/${name}-src.tar.bz2";
      sha256 = "17jv2pz0mbkkf7jw3jcpix8hb46b382hc7vki42n9rrdynydq5zp";
  };

  cmakeFlags = [
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
    "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG"
    "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG"
  ];

  buildInputs = [
    cmake irrlicht libpng bzip2 libjpeg sqlite
    libXxf86vm mesa openal libvorbis x11 pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = http://voxelands.com/;
    description = "Infinite-world block sandbox game based on Minetest";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jgeerds c0dehero ];
  };
}
