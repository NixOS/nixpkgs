{ lib, stdenv
, fetchFromGitLab
, bzip2
, cmake
, expat
, irrlicht
, libGL
, libGLU
, libXxf86vm
, libjpeg
, libpng
, libvorbis
, openal
, pkg-config
, sqlite
, xlibsWrapper
}:

stdenv.mkDerivation rec {
  pname = "voxelands";
  version = "1704.00";

  src = fetchFromGitLab {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0yj9z9nygpn0z63y739v72l3kg81wd71xgix5k045vfzhqsam5m0";
  };

  cmakeFlags = [
    "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
    "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG"
    "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    bzip2
    expat
    irrlicht
    libGL
    libGLU
    libXxf86vm
    libjpeg
    libpng
    libvorbis
    openal
    sqlite
    xlibsWrapper
  ];

  meta = with lib; {
    homepage = "https://voxelands.net/";
    description = "Infinite-world block sandbox game based on Minetest";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    broken = stdenv.isAarch64;  # build fails with "libIrrlicht.so: undefined reference to `png_init_filter_functions_neon'"
  };
}
