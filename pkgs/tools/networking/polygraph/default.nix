{ stdenv, fetchurl, openssl, zlib, ncurses }:

stdenv.mkDerivation rec {
  name = "polygraph-4.3.2";

  src = fetchurl {
    url = "http://www.web-polygraph.org/downloads/srcs/${name}-src.tgz";
    sha256 = "1fv9jpcicfsgsmghkykqif6l6w7nwvk5xbdmpv72jbrwzx44845h";
  };

  buildInputs = [ openssl zlib ncurses ];
  
  patches = [ ./fix_build.patch ];

  meta = with stdenv.lib; {
    homepage = http://www.web-polygraph.org;
    description = "Performance testing tool for caching proxies, origin server accelerators, L4/7 switches, content filters, and other Web intermediaries";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}