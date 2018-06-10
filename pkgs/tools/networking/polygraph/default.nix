{ stdenv, fetchurl, openssl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "polygraph-4.11.0";

  src = fetchurl {
    url = "http://www.web-polygraph.org/downloads/srcs/${name}-src.tgz";
    sha256 = "1ii60yl3p89qawvl19sd1bkpkw39fz8kpvmc3cawa32nxzbm9pbs";
  };

  buildInputs = [ openssl zlib ncurses ];
  
  meta = with stdenv.lib; {
    homepage = http://www.web-polygraph.org;
    description = "Performance testing tool for caching proxies, origin server accelerators, L4/7 switches, content filters, and other Web intermediaries";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
