{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2017.11.27";

  # You can find new releases on http://ifdo.ca/~seymour/runabc/top.html
  src = fetchurl {
    url = "http://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "095nnyaqnsr3v7hsswpad9g0hxdnr4s6z8yk1bmr3g1j0cfv1xs9";
  };

  nativeBuildInputs = [ unzip ];

  # There is also a file called "makefile" which seems to be preferred by the standard build phase
  makefile = "Makefile";

  meta = with stdenv.lib; {
    homepage = http://abc.sourceforge.net/abcMIDI/;
    license = licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    maintainers = [ maintainers.dotlambda ];
  };
}
