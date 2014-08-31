{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "byacc-1.9";

  src = fetchurl {
    url = http://invisible-island.net/datafiles/release/byacc.tar.gz;
    sha256 = "1rbzx5ipkvih9rjfdfv6310wcr6mxjbdlsh9zcv5aaz6yxxxil7c";
  };

  meta = { 
    description = "Berkeley YACC";
    homepage = http://dickey.his.com/byacc/byacc.html;
    license = "public domain";
  };
}
