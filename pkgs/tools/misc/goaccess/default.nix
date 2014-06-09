{ stdenv, fetchurl, pkgconfig, geoip, ncurses, glib }:

let
  version = "0.8";
  mainSrc = fetchurl {
    url = "http://tar.goaccess.prosoftcorp.com/goaccess-${version}.tar.gz";
    sha256 = "a61215b1f3e82bdb50c892e843f1a85d6d85f882915d694a5672911fab955eea";
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
    description = "GoAccess is an open source real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems.";
    homepage    = http://goaccess.prosoftcorp.com;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 ];
  };
}
