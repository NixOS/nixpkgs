{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.17";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "sha256-gQdFqO0as3iMh9OupMwaFO327iJvdkvMOD4CS6Vq2/E=";
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "Disk usage analyzer with an ncurses interface";
    homepage = "https://dev.yorhel.nl/ncdu";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub SuperSandro2000 ];
  };
}
