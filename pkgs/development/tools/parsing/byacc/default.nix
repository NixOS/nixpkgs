{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "byacc-1.9";

  src = fetchurl {
    url = ftp://invisible-island.net/byacc/byacc-20140715.tgz;
    sha256 = "1rbzx5ipkvih9rjfdfv6310wcr6mxjbdlsh9zcv5aaz6yxxxil7c";
  };

  meta = {
    description = "Berkeley YACC";
    homepage = http://dickey.his.com/byacc/byacc.html;
    license = stdenv.lib.licenses.publicDomain;
    platforms = stdenv.lib.platforms.unix;
  };
}
