{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "sndio-${version}";
  version = "1.2.0";
  enableParallelBuilding = true;
  buildInputs = [ alsaLib ];

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "1p3cw7s6ylmvafbf9a5w5bkh3cy4s1d73hdh0i24m441jhc8x05r";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
