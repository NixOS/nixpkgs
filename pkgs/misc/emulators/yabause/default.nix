{ stdenv, fetchurl, cmake, pkgconfig, qtbase, libGLU_combined
, freeglut ? null, openal ? null, SDL2 ? null }:

stdenv.mkDerivation rec {
  name = "yabause-${version}";
  # 0.9.15 only works with OpenGL 3.2 or later:
  # https://github.com/Yabause/yabause/issues/349
  version = "0.9.14";

  src = fetchurl {
    url = "https://download.tuxfamily.org/yabause/releases/${version}/${name}.tar.gz";
    sha256 = "0nkpvnr599g0i2mf19sjvw5m0rrvixdgz2snav4qwvzgfc435rkm";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ qtbase libGLU_combined freeglut openal SDL2 ];

  patches = [ ./emu-compatibility.com.patch ./linkage-rwx-linux-elf.patch ];

  cmakeFlags = [
    "-DYAB_NETWORK=ON"
    "-DYAB_OPTIMIZED_DMA=ON"
    "-DYAB_PORTS=qt"
  ] ;

  meta = with stdenv.lib; {
    description = "An open-source Sega Saturn emulator";
    homepage = https://yabause.org/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
