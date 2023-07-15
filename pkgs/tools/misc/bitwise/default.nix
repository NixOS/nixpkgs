{ lib, stdenv, fetchFromGitHub, ncurses, readline, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bitwise";
  version = "0.43";

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${version}";
    sha256 = "18sz7bfpq83s2zhw7c35snz6k3b6rzad2mmfq2qwmyqwypbp1g7l";
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
