{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2019.06.06";

  src = fetchzip {
    url = "https://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "1vmz2vj6asvy254y2ap89ah46lxr4pcw7bb827wrs3rzcysmcwjf";
  };

  # There is also a file called "makefile" which seems to be preferred by the standard build phase
  makefile = "Makefile";

  meta = with stdenv.lib; {
    homepage = http://abc.sourceforge.net/abcMIDI/;
    downloadPage = https://ifdo.ca/~seymour/runabc/top.html;
    license = licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
  };
}
