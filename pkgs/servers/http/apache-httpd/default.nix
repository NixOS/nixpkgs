{ stdenv, fetchurl, openssl, db4, expat, perl
, sslSupport, db4Support
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.0.53";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/apache.org/dist/httpd/httpd-2.0.53.tar.bz2;
    md5 = "94f3a793fb1665365724943206cce23f";
  };

  inherit sslSupport db4Support;

  inherit perl expat;
  openssl = if sslSupport then openssl else null;
  db4 = if db4Support then db4 else null;
}
