{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
<<<<<<< HEAD
  version = "1.18.1";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-fA+h6ynYWq7UuhdBZL27jwEbXDkNAXxX1mj8cjEzJAU=";
=======
  version = "1.17";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-gQdFqO0as3iMh9OupMwaFO327iJvdkvMOD4CS6Vq2/E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
<<<<<<< HEAD
    maintainers = with maintainers; [ pSub ];
    mainProgram = "ncdu";
=======
    maintainers = with maintainers; [ pSub SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
