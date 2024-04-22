{ lib, stdenv, fetchurl, autoconf, automake, ncurses }:

stdenv.mkDerivation rec {
  pname = "conspy";
  version = "1.16";

  src = fetchurl {
    url = "mirror://sourceforge/project/conspy/conspy-${version}-1/conspy-${version}.tar.gz";
    sha256 = "02andak806vd04bgjlr0y0d2ddx7cazyf8nvca80vlh8x94gcppf";
    curlOpts = " -A application/octet-stream ";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [
    ncurses
  ];

  preConfigure = ''
    touch NEWS
    echo "EPL 1.0" > COPYING
    aclocal
    automake --add-missing
    autoconf
  '';

  meta = with lib; {
    description = "Linux text console viewer";
    mainProgram = "conspy";
    license = licenses.epl10;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
