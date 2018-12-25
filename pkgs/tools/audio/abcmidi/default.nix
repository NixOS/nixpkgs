{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2018.12.01";

  src = fetchzip {
    url = "https://ifdo.ca/~seymour/runabc/${name}.zip";
    sha256 = "133kdyin2lwidlnd8ivjyymrrb0rr1028apj2biyp6l0l5yrqw78";
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
