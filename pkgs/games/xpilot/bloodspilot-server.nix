{ lib, stdenv, fetchurl, expat }:

stdenv.mkDerivation rec {
  pname = "bloodspilot-xpilot-fxi-server";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/bloodspilot/server/server%20v${version}/xpilot-${version}fxi.tar.gz";
    sha256 = "0d7hnpshifq6gy9a0g6il6h1hgqqjyys36n8w84hr8d4nhg4d1ji";
  };

  buildInputs = [
    expat
  ];

  patches = [
    ./server-gcc5.patch
  ];

  meta = with lib; {
    description = "Multiplayer X11 space combat game (server part)";
    mainProgram = "xpilots";
    homepage = "http://bloodspilot.sf.net/";
    license = licenses.gpl2Plus ;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
