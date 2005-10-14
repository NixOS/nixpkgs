{ stdenv, fetchurl, openssl, db4, expat, perl
, sslSupport, db4Support
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.0.55";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://apache.cs.uu.nl/dist/httpd/httpd-2.0.55.tar.bz2;
    md5 = "f1b5b65c8661db9ffe38b5a4a865a0e2";
  };

  inherit sslSupport db4Support;

  inherit perl expat;
  openssl = if sslSupport then openssl else null;
  db4 = if db4Support then db4 else null;
}
