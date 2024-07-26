{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "abcMIDI";
  version = "2024.03.05";

  src = fetchzip {
    url = "https://ifdo.ca/~seymour/runabc/${pname}-${version}.zip";
    hash = "sha256-nZVI+fIS5av+RUX4P1CsncnQUuqDmIRoT1TGRLdg2Bg=";
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
