{ fetchFromGitHub, stdenv, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-2.0.0";

  src = fetchFromGitHub {
    sha256 = "1z8rzf3ndswk3090qypl0bqzq9f32w0ik2k5x4zd7jg4hkx66k7z";
    rev = "2.0.0";
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
