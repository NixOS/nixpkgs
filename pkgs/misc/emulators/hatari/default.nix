{ stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  pname = "hatari";
  version = "2.3.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/hatari/${version}/${pname}-${version}.tar.bz2";
    sha256 = "19dqadi32hgi78hyxxcm8v2vh28vyn9w5nd1xiq683wk0ccicj5z";
  };

  # For pthread_cancel
  cmakeFlags = [ "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s" ];

  buildInputs = [ zlib SDL cmake ];

  meta = {
    homepage = "http://hatari.tuxfamily.org/";
    description = "Atari ST/STE/TT/Falcon emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
