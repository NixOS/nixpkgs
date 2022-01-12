{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "ncdu";
  version = "1.16";

  src = fetchurl {
    url = "https://dev.yorhel.nl/download/${pname}-${version}.tar.gz";
    sha256 = "1m0gk09jaz114piidiw8fkg0id5l6nhz1cg5nlaf1yl3l595g49b";
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
