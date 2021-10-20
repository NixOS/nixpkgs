{ lib, stdenv, fetchFromGitHub, ncurses, readline, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bitwise";
  version = "0.42";

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${version}";
    sha256 = "154y0sn3z64z56k84ghsazkyihbkaz40hfwxcxdymnhvhh6m9f3g";
  };

  buildInputs = [ ncurses readline ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Terminal based bitwise calculator in curses";
    homepage = "https://github.com/mellowcandle/bitwise";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.whonore ];
    platforms = platforms.unix;
  };
}
