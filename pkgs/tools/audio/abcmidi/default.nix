{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "abcMIDI-${version}";
  version = "2017.06.10";

  src = fetchFromGitHub {
    owner = "leesavide";
    repo = "abcmidi";
    rev = name;
    sha256 = "0y92m3mj63vvy79ksq4z5hgkz6w50drg9a4bmbk6jylny0l0bdpy";
  };

  # There is also a file called "makefile" which seems to be preferred by the standard build phase
  makefile = "Makefile";

  meta = with stdenv.lib; {
    homepage = http://abc.sourceforge.net/abcMIDI/;
    license = licenses.gpl2Plus;
    description = "abc <-> MIDI conversion utilities";
    maintainers = [ maintainers.dotlambda ];
  };
}
