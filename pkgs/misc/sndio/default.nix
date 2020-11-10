{ stdenv, fetchurl, alsaLib, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "sndio";
  version = "1.7.0";
  enableParallelBuilding = true;
  nativeBuildInputs = stdenv.lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;
  buildInputs = stdenv.lib.optional stdenv.hostPlatform.isLinux alsaLib;

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "0ljmac0lnjn61admgbcwjfcr5fwccrsblx9rj9bys8wlhz8f796x";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
