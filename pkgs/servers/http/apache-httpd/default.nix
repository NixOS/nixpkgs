{ stdenv, fetchurl, openssl, db4, expat, perl
, sslSupport, db4Support
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

derivation {
  name = "apache-httpd-2.0.49";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/apache.org/dist/httpd/httpd-2.0.49.tar.gz;
    md5 = "275d3d37eed1b070f333d3618f7d1954";
  };

  inherit sslSupport db4Support;

  inherit stdenv perl expat;
  openssl = if sslSupport then openssl else null;
  db4 = if db4Support then db4 else null;
}
