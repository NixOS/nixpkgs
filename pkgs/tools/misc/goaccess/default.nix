{ stdenv, fetchurl, pkgconfig, ncurses, glib, libmaxminddb }:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "goaccess";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "1gkpjg39f3afdwm9128jqjsfap07p8s027czzlnxfmi5hpzvkyz8";
  };

  configureFlags = [
    "--enable-geoip=mmdb"
    "--enable-utf8"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    libmaxminddb
    ncurses
    glib
  ];

  meta = {
    description = "Real-time web log analyzer and interactive viewer that runs in a terminal in *nix systems";
    homepage    = "https://goaccess.io";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 ];
  };
}
