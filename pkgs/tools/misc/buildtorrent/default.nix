{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "buildtorrent";
  version = "0.8";

  src = fetchurl {
    url = "https://mathr.co.uk/blog/code/${pname}-${version}.tar.gz";
    sha256 = "sha256-6OJ2R72ziHOsVw1GwalompKwG7Z/WQidHN0IeE9wUtA=";
  };

  meta = with lib; {
    description = "A simple commandline torrent creator";
    homepage = "https://mathr.co.uk/blog/torrent.html";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    mainProgram = "buildtorrent";
  };
}
