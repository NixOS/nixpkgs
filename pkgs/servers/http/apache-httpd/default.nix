{ stdenv, fetchurl, openssl, db4, expat, perl, zlib
, sslSupport, db4Support
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.2.8";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://archive.apache.org/dist/httpd/httpd-2.2.8.tar.bz2;
    md5 = "76d2598a4797163d07cd50e5304aa7cd";
  };

  inherit sslSupport db4Support;

  inherit perl expat zlib;
  openssl = if sslSupport then openssl else null;
  db4 = if db4Support then db4 else null;

  # For now, disable detection of epoll to ensure that Apache still
  # runs on Linux 2.4 kernels.  Once we've dropped support for 2.4 in
  # Nixpkgs, this can go.  In general, it's a problem that APR
  # detects characteristics of the build system's kernel to decide
  # what to use at runtime, since it's impure.
  apr_cv_epoll = "no";
  
  meta = {
    description = "Apache HTTPD, the world's most popular web server";
  };
}
