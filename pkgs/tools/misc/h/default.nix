<<<<<<< HEAD
{ lib, stdenv, fetchFromGitHub, ruby }:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.4";
=======
{ lib, stdenv, fetchFromGitHub, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-eitUKOo2c1c+SyctkUW/SUb2RCKUoU6nJplfJVdwBSs=";
=======
    hash = "sha256-RyQZ9F+rZ0a/90hljSyNCzYK8eA3rYJlJkV7B5NPRzY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir -p $out/bin
    cp h $out/bin/h
    cp up $out/bin/up
  '';

  meta = with lib; {
    description = "faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
  };
}
