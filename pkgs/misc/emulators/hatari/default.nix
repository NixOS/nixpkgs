{ stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  name = "hatari-1.8.0";

  src = fetchurl {
    url = "http://download.tuxfamily.org/hatari/1.8.0/${name}.tar.bz2";
    sha256 = "1szznnndmbyc71751hir3dhybmbrx3rnxs6klgbv9qvqlmmlikvy";
  };

  # For pthread_cancel
  cmakeFlags = "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s";

  buildInputs = [ zlib SDL cmake ];

  meta = {
    homepage = http://hatari.tuxfamily.org/;
    description = "Atari ST/STE/TT/Falcon emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
