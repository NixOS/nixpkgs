{ stdenv, fetchurl, pkgconfig, geoip, ncurses, glib }:

let
  version = "0.9";
  mainSrc = fetchurl {
    url = "http://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "1yi7bxrmhvd11ha405bqpz7q442l9bnnx317iy22xzxjl96frn29";
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
    geoip
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
