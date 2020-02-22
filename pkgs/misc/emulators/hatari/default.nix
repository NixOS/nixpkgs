{ stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  name = "hatari-2.2.1";

  src = fetchurl {
    url = "https://download.tuxfamily.org/hatari/2.2.1/${name}.tar.bz2";
    sha256 = "0q3g23vnx58w666723v76ilh9j353md3sn48cmlq9gkll8qfzbqi";
  };

  # For pthread_cancel
  cmakeFlags = [ "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s" ];

  buildInputs = [ zlib SDL cmake ];

  meta = {
    homepage = http://hatari.tuxfamily.org/;
    description = "Atari ST/STE/TT/Falcon emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
