{ stdenv, fetchurl, pkgconfig, geoip, ncurses, glib }:

let
  version = "0.8.5";
  mainSrc = fetchurl {
    url = "http://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "121s1hva33nq0g5n354ln68nalv2frg8slm7n84r81bmi2wvdim4";
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
