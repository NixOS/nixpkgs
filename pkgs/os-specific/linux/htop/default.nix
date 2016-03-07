{ fetchFromGitHub, stdenv, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    sha256 = "0llj8ixgyjjq9vymsiysv7qnlc7f04jzm6lc9wm7nhcnymn7jg8z";
    rev = version;
    repo = "htop";
    owner = "hishamhm";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    touch *.h */*.h # unnecessary regeneration requires Python
  '';

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rob simons relrod ];
  };
}
