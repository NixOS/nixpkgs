{ stdenv, fetchurl, openssl, db4, expat, perl
, sslSupport, db4Support
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.0.52";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/httpd-2.0.52.tar.bz2;
    md5 = "0e1b47c53921a1fc8fb006effdb3bf1c";
  };

  inherit sslSupport db4Support;

  inherit perl expat;
  openssl = if sslSupport then openssl else null;
  db4 = if db4Support then db4 else null;
}
