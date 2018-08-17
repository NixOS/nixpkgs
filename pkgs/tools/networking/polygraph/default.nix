{ stdenv, fetchurl, openssl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "polygraph-4.12.0";

  src = fetchurl {
    url = "http://www.web-polygraph.org/downloads/srcs/${name}-src.tgz";
    sha256 = "1anrdc30yi9pb67642flmn7w82q37cnc45r9bh15mpbc66yk3kzz";
  };

  buildInputs = [ openssl zlib ncurses ];
  
  meta = with stdenv.lib; {
    homepage = http://www.web-polygraph.org;
    description = "Performance testing tool for caching proxies, origin server accelerators, L4/7 switches, content filters, and other Web intermediaries";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
