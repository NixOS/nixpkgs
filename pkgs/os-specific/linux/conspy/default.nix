{stdenv, fetchurl, autoconf, automake, ncurses}:
let
  s = # Generated upstream information
  rec {
    baseName="conspy";
    version="1.9";
    name="${baseName}-${version}";
    hash="1ndwdx8x5lnjl6cddy1d8g8m7ndxyj3wrs100w2bp9gnvbxbb8vv";
    url="http://ace-host.stuart.id.au/russell/files/conspy/conspy-1.9.tar.gz";
    sha256="1ndwdx8x5lnjl6cddy1d8g8m7ndxyj3wrs100w2bp9gnvbxbb8vv";
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
