{ lib, stdenv, fetchFromGitHub, ncurses, readline, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "bitwise";
<<<<<<< HEAD
  version = "0.50";
=======
  version = "0.43";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mellowcandle";
    repo = "bitwise";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-x+ky1X0c0bQZnkNvNNuXN2BoMDtDSCt/8dBAG92jCCQ=";
=======
    sha256 = "18sz7bfpq83s2zhw7c35snz6k3b6rzad2mmfq2qwmyqwypbp1g7l";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
