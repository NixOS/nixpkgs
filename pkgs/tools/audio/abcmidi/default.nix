{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2018.01.02";

  # You can find new releases on http://ifdo.ca/~seymour/runabc/top.html
  src = fetchzip {
    url = "http://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "0s8wm637dgzgpgdxba3a6fh06i0c4iwvv9cdghh8msnx428k68iw";
  };

  # There is also a file called "makefile" which seems to be preferred by the standard build phase
  makefile = "Makefile";

  meta = with stdenv.lib; {
    homepage = http://abc.sourceforge.net/abcMIDI/;
    license = licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    maintainers = [ maintainers.dotlambda ];
  };
}
