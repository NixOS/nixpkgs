{ stdenv, fetchurl, pkgconfig, geoipWithDatabase, ncurses, glib }:

stdenv.mkDerivation rec {
  version = "1.2";
  name = "goaccess-${version}";

  src = fetchurl {
    url = "https://tar.goaccess.io/goaccess-${version}.tar.gz";
    sha256 = "051lrprg9svl5ccc3sif8fl78vfpkrgjcxgi2wngqn7a81jzdabb";
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
    homepage    = http://goaccess.prosoftcorp.com;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = with stdenv.lib.maintainers; [ ederoyd46 garbas ];
  };
}
