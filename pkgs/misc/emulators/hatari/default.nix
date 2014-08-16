{ stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  name = "hatari-1.6.2";

  src = fetchurl {
    url = "http://download.tuxfamily.org/hatari/1.6.2/${name}.tar.bz2";
    sha256 = "0gqvfqqd0lg3hi261rwh6gi2b5kmza480kfzx43d4l49xcq09pi0";
  };

  # For pthread_cancel
  cmakeFlags = "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s";

  buildInputs = [ zlib SDL cmake ];

  meta = {
    homepage = "http://hatari.tuxfamily.org/";
    description = "Atari ST/STE/TT/Falcon emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
