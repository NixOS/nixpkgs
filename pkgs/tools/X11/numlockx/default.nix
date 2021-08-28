{ lib, stdenv, fetchFromGitHub, libX11, libXext, autoconf }:

stdenv.mkDerivation rec {
  version = "1.2";
  pname = "numlockx";

  src = fetchFromGitHub {
    owner = "rg3";
    repo = pname;
    rev = "9159fd3c5717c595dadfcb33b380a85c88406185";
    sha256 = "1w49fayhwzn5rx0z1q2lrvm7z8jrd34lgb89p853a024bixc3cf2";
  };

  buildInputs = [ libX11 libXext autoconf ];

  meta = with lib; {
    description = "Allows to start X with NumLock turned on";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
