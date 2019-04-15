{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  pname = "sndio";
  version = "1.5.0";

  src = fetchurl {
    url = "http://www.sndio.org/${pname}-${version}.tar.gz";
    sha256 = "0lyjb962w9qjkm3yywdywi7k2sxa2rl96v5jmrzcpncsfi201iqj";
  };

  buildInputs = [ alsaLib ];

  outputs = [ "out" "dev" "man" ];
  setOutputFlags = false;

  postInstall = ''
    moveToOutput lib $dev
    moveToOutput include $dev
    moveToOutput share/man $man
  '';

  meta = with stdenv.lib; {
    description = "A small sound server and an audio and MIDI framework, originally part of the OpenBSD project";
    homepage    = http://www.sndio.org/;
    license     = licenses.isc;
    maintainers = with maintainers; [ ajs124 ];
  };
}
