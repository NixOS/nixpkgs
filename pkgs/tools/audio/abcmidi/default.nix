{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2017.12.10";

  # You can find new releases on http://ifdo.ca/~seymour/runabc/top.html
  src = fetchzip {
    url = "http://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "0m6mv6hlpzg14y5vsjicvi6lpmymsi1q4wz8sfliric3n1zb7ygz";
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
