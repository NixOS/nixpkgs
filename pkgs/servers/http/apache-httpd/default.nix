{ stdenv, fetchurl, openssl, db4, expat, perl
, sslSupport, db4Support
}:

assert sslSupport -> !isNull openssl;
assert db4Support -> !isNull db4;
assert !isNull expat && !isNull perl;

derivation {
  name = "apache-httpd-2.0.48";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.cs.uu.nl/mirror/apache.org/dist/httpd/httpd-2.0.48.tar.gz;
    md5 = "466c63bb71b710d20a5c353df8c1a19c";
  };

  sslSupport = sslSupport;
  db4Support = db4Support;

  stdenv = stdenv;
  perl = perl;
  openssl = if sslSupport then openssl else "";
  db4 = if db4Support then db4 else "";
  expat = expat;
}
