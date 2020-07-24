{ stdenv, lib, fetchFromGitHub, autoreconfHook, ronn }:

stdenv.mkDerivation rec {
  pname = "flock";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "discoteq";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vdq22zhdfi7wwndsd6s7fwmz02fsn0x04d7asq4hslk7bjxjjzn";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ronn ];

  meta = with lib; {
    description = "Cross-platform version of flock(1)";
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.all;
    license = licenses.isc;
  };
}
