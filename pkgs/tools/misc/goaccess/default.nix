{ stdenv, fetchurl, pkgconfig, geoipWithDatabase, ncurses, glib }:

let
  version = "0.9.4";
  mainSrc = fetchurl {
    url = "http://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "1kn5yvgzrzjlxd0zhr2d2gbjdin9j9vmfbk5gkrwqc4kd9zicvla";
  };
in

stdenv.mkDerivation rec {
  name = "goaccess-${version}";
  src = mainSrc;

  configureFlags = [
    "--enable-geoip"
    "--enable-utf8"
  ];

  buildInputs = [
    pkgconfig
    geoipWithDatabase
    ncurses
    glib
  ];

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage    = http://goaccess.prosoftcorp.com;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 ];
  };
}
