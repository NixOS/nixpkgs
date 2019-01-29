{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2019.01.01";

  src = fetchzip {
    url = "https://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "10kqxw4vrz7xa8fc9z5cdyrvks8fsr2s9nai9yg1z9p5w7xhagrg";
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
