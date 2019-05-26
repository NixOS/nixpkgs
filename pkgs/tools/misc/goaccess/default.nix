{ stdenv, fetchurl, pkgconfig, geoipWithDatabase, ncurses, glib }:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "goaccess-${version}";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "16vv3pj7pbraq173wlxa89jjsd279004j4kgzlrsk1dz4if5qxwc";
  };

  configureFlags = [
    "--enable-geoip"
    "--enable-utf8"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    geoipWithDatabase
    ncurses
    glib
  ];

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage    = https://goaccess.io;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 garbas ];
  };
}
