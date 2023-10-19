{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "abcMIDI";
  version = "2023.09.13";

  src = fetchzip {
    url = "https://ifdo.ca/~seymour/runabc/${pname}-${version}.zip";
    hash = "sha256-rpGINfLuWHu6QA/30aI9B8Hmpfx1o6vstiQn+t0blxA=";
  };

  meta = with lib; {
    homepage = "https://abc.sourceforge.net/abcMIDI/";
    downloadPage = "https://ifdo.ca/~seymour/runabc/top.html";
    license = licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
