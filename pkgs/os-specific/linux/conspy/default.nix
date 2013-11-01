{stdenv, fetchurl, autoconf, automake, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="conspy";
    version="1.8";
    name="${baseName}-${version}";
    hash=sha256;
    url="http://ace-host.stuart.id.au/russell/files/conspy/conspy-1.8.tar.gz";
    sha256="1jc2maqp4w4mzlr3s8yni03w1p9sir5hb7gha3ffxj4n32nx42dq";
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
    license = stdenv.lib.licenses.epl10 ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
