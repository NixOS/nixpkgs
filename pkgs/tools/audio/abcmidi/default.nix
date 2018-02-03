{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2018.01.25";

  src = fetchzip {
    url = "http://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "18h6gqhh75qdi8krpp0m2pxbxi0n08wrh8xay477jm3vaggyr8s9";
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
