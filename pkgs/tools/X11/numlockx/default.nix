<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, autoconf, libX11, libXext }:

stdenv.mkDerivation {
=======
{ lib, stdenv, fetchFromGitHub, libX11, libXext, autoconf }:

stdenv.mkDerivation rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  version = "1.2";
  pname = "numlockx";

  src = fetchFromGitHub {
    owner = "rg3";
<<<<<<< HEAD
    repo = "numlockx";
    rev = "9159fd3c5717c595dadfcb33b380a85c88406185";
    hash = "sha256-wrHBelxEADUKugmtR8loWaJ/6s5U4PBBz8V+Dr1yifA=";
=======
    repo = pname;
    rev = "9159fd3c5717c595dadfcb33b380a85c88406185";
    sha256 = "1w49fayhwzn5rx0z1q2lrvm7z8jrd34lgb89p853a024bixc3cf2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ libX11 libXext autoconf ];

<<<<<<< HEAD
  meta = {
    description = "Allows to start X with NumLock turned on";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "numlockx";
=======
  meta = with lib; {
    description = "Allows to start X with NumLock turned on";
    license = licenses.mit;
    platforms = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
