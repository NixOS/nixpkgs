{stdenv, fetchurl, mysql, libxslt, zlib, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "sysbench-0.4.12";
  buildInputs = [ autoreconfHook mysql libxslt zlib ];
  src = fetchurl {
    url = mirror://sourceforge/sysbench/sysbench-0.4.12.tar.gz;
    sha256 = "17pa4cw7wxvlb4mba943lfs3b3jdi64mlnaf4n8jq09y35j79yl3";
  };
  preAutoreconf = ''
    touch NEWS AUTHORS
  '';

  meta = {
    description = "Modular, cross-platform and multi-threaded benchmark tool";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}
