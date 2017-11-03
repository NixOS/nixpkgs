{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, tokyocabinet, cairo, pango, ncurses }:

stdenv.mkDerivation rec {
  name = "duc-${version}";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "zevv";
    repo = "duc";
    rev = "${version}";
    sha256 = "1h7vll8a78ijan9bmnimmsviywmc39x8h9iikx8vm98kwyxi4xif";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ tokyocabinet cairo pango ncurses ];

  meta = with stdenv.lib; {
    homepage = http://duc.zevv.nl/;
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = licenses.gpl2;

    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
