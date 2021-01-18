{ lib, stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  pname = "hatari";
  version = "2.3.0";

  src = fetchurl {
    url = "https://download.tuxfamily.org/hatari/${version}/${pname}-${version}.tar.bz2";
    sha256 = "19dqadi32hgi78hyxxcm8v2vh28vyn9w5nd1xiq683wk0ccicj5z";
  };

  # For pthread_cancel
  cmakeFlags = [ "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib SDL ];

  meta = {
    homepage = "http://hatari.tuxfamily.org/";
    description = "Atari ST/STE/TT/Falcon emulator";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
