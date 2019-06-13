{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "sndio-${version}";
  version = "1.5.0";
  enableParallelBuilding = true;
  buildInputs = [ alsaLib ];

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "0lyjb962w9qjkm3yywdywi7k2sxa2rl96v5jmrzcpncsfi201iqj";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
