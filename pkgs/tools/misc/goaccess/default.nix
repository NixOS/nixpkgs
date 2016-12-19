{ stdenv, fetchurl, pkgconfig, geoipWithDatabase, ncurses, glib }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "goaccess-${version}";

  src = fetchurl {
    url = "http://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "1zma9p0gwxwl9kgq47i487fy1q8567fqnpik0zacjhgmpnzry3h0";
  };

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
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 garbas ];
  };
}
