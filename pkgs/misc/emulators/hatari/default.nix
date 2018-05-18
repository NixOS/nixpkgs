{ stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  name = "hatari-2.1.0";

  src = fetchurl {
    url = "http://download.tuxfamily.org/hatari/2.1.0/${name}.tar.bz2";
    sha256 = "0909l9fq20ninf8xgv5qf0a5y64cpk5ja1rsk2iaid1dx5h98agb";
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
