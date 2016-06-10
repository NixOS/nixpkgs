{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, tokyocabinet, cairo, pango, ncurses }:

stdenv.mkDerivation rec {
  name = "duc-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "duc";
    rev = "${version}";
    sha256 = "0rnar2zacsb9rvdmp1a62xixhy69s5vh0nwgrklqxhb19qkzhdp7";
  };

  buildInputs = [ autoreconfHook pkgconfig tokyocabinet cairo pango ncurses ];

  meta = with stdenv.lib; {
    homepage = http://duc.zevv.nl/;
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = licenses.gpl2;

    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
