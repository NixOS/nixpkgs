{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "abcMIDI";
  version = "2021.12.05";

  src = fetchzip {
    url = "https://ifdo.ca/~seymour/runabc/${pname}-${version}.zip";
    hash = "sha256-q3iyIheV7g6l2S6CSKqt9VQKa9i8xg5RKOO3JfFXuLI=";
  };

  meta = with lib; {
    homepage = "http://abc.sourceforge.net/abcMIDI/";
    downloadPage = "https://ifdo.ca/~seymour/runabc/top.html";
    license = licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
