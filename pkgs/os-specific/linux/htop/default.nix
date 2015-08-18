{ fetchFromGitHub, stdenv, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-1.0.3-186-gf2c053a";

  src = fetchFromGitHub {
    sha256 = "017aihyg0bjli1hlvcqgqxpwzy2ayvwv6byhqd97n9sqfkmi9i0p";
    rev = "f2c053a88497f3ad5ae786c16ecf1275212c13be";
    repo = "htop";
    owner = "hishamhm";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rob simons relrod ];
  };
}
