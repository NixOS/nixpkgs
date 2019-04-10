{ stdenv, fetchurl, openssl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "polygraph-4.13.0";

  src = fetchurl {
    url = "http://www.web-polygraph.org/downloads/srcs/${name}-src.tgz";
    sha256 = "1rwzci3n7q33hw3spd79adnclzwgwlxcisc9szzjmcjqhbkcpj1a";
  };

  buildInputs = [ openssl zlib ncurses ];

  meta = with stdenv.lib; {
    homepage = http://www.web-polygraph.org;
    description = "Performance testing tool for caching proxies, origin server accelerators, L4/7 switches, content filters, and other Web intermediaries";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.lethalman ];
  };
}
