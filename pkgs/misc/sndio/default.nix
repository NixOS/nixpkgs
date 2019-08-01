{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "sndio-${version}";
  version = "1.6.0";
  enableParallelBuilding = true;
  buildInputs = [ alsaLib ];

  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "1havdx3q4mipgddmd2bnygr1yh6y64567m1yqwjapkhsq550dq4r";
  };

  meta = with stdenv.lib; {
    homepage = "http://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = licenses.isc;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
