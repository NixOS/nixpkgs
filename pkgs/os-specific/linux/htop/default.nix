{ fetchFromGitHub, stdenv, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-1.0.3-239-229d0058";

  src = fetchFromGitHub {
    sha256 = "1bym6ligd8db4iyv2m1y7aylh7f9fmk71v67rkhird05hx1xb80r";
    rev = "229d005851af8dca595b3df8e385375fb9c382b4";
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
