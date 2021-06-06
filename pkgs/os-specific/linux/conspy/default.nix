{lib, stdenv, fetchurl, autoconf, automake, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="conspy";
    version="1.16";
    name="${baseName}-${version}";
    hash="02andak806vd04bgjlr0y0d2ddx7cazyf8nvca80vlh8x94gcppf";
    url="mirror://sourceforge/project/conspy/conspy-1.16-1/conspy-1.16.tar.gz";
    sha256="02andak806vd04bgjlr0y0d2ddx7cazyf8nvca80vlh8x94gcppf";
  };
  buildInputs = [
    autoconf automake ncurses
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
    curlOpts = " -A application/octet-stream ";
  };
  preConfigure = ''
    touch NEWS
    echo "EPL 1.0" > COPYING
    aclocal
    automake --add-missing
    autoconf
  '';
  meta = {
    inherit (s) version;
    description = "Linux text console viewer";
    license = lib.licenses.epl10 ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
