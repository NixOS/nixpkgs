{ lib, stdenv, fetchFromGitHub, autoconf, libX11, libXext }:

stdenv.mkDerivation {
  version = "1.2";
  pname = "numlockx";

  src = fetchFromGitHub {
    owner = "rg3";
    repo = "numlockx";
    rev = "9159fd3c5717c595dadfcb33b380a85c88406185";
    hash = "sha256-wrHBelxEADUKugmtR8loWaJ/6s5U4PBBz8V+Dr1yifA=";
  };

  buildInputs = [ libX11 libXext autoconf ];

  meta = {
    description = "Allows to start X with NumLock turned on";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "numlockx";
  };
}
