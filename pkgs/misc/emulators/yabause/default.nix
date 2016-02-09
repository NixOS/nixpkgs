{ stdenv, fetchurl, config
, cmake, pkgconfig
, doxygen
, qt
, libXmu, mesa, openal, SDL2, freeglut
}:

stdenv.mkDerivation rec {
  name = "yabause-${meta.version}";

  src = fetchurl {
    url = "http://download.tuxfamily.org/yabause/releases/${meta.version}/${name}.tar.gz";
    sha256 = "0nkpvnr599g0i2mf19sjvw5m0rrvixdgz2snav4qwvzgfc435rkm";
  };

  patches = [ ./linkage-rwx-linux-elf.diff ];

  buildInputs =
  [ cmake pkgconfig doxygen qt libXmu mesa openal SDL2 freeglut ];

  cmakeConfigureFlags = [    
    "-DYAB_PORTS='qt'"
    "-DYAB_OPTIMIZED_DMA='ON'"
    "-DYAB_NETWORK='ON'" ] ;

  meta = with stdenv.lib; {
    version = "0.9.14";
    description = "An open-source Sega Saturn emulator";
    homepage = http://yabause.org/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
# TODO: Qt5
