{stdenv, fetchurl, expat}:
let
  buildInputs = [
    expat
  ];
in
stdenv.mkDerivation rec {
  version = "1.4.6";
  name = "bloodspilot-xpilot-fxi-server-${version}";
  inherit buildInputs;
  src = fetchurl {
    url = "mirror://sourceforge/project/bloodspilot/server/server%20v${version}/xpilot-${version}fxi.tar.gz";
    sha256 = "0d7hnpshifq6gy9a0g6il6h1hgqqjyys36n8w84hr8d4nhg4d1ji";
  };
  meta = {
    inherit version;
    description = ''A multiplayer X11 space combat game (server part)'';
    homepage = "http://bloodspilot.sf.net/";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
