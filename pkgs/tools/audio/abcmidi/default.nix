{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2017.12.20";

  # You can find new releases on http://ifdo.ca/~seymour/runabc/top.html
  src = fetchzip {
    url = "http://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "0lkbwrh701djbyqmybvx860p8csy25i6p3p7hr0cpndpa496nm07";
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
