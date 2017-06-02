{ stdenv, fetchFromGitHub, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "pick-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "thoughtbot";
    repo = "pick";
    rev = "v${version}";
    sha256 = "0iw3yqwg8j0pg56xx52xwn7n95vxlqbqh71zrc934v4mq971qlhd";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    sed -i -e 's/\[curses]/\[ncurses]/g' configure.ac
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy text selection utility";
    license = licenses.mit;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux ++ platforms.darwin;
  };

}
