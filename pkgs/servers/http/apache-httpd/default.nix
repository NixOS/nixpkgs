{ stdenv, fetchurl, openssl, db4, expat, perl, zlib
, sslSupport, db4Support, proxySupport ? true
}:

assert sslSupport -> openssl != null;
assert db4Support -> db4 != null;
assert expat != null && perl != null;

stdenv.mkDerivation {
  name = "apache-httpd-2.2.9";

  src = fetchurl {
    url = mirror://apache/httpd/httpd-2.2.9.tar.bz2;
    md5 = "3afa8137dc1999be695a20b62fdf032b";
  };

  #inherit sslSupport db4Support;

  buildInputs = [expat perl] ++
    stdenv.lib.optional sslSupport openssl ++
    stdenv.lib.optional db4Support db4;

  configureFlags = ''
    --with-expat=${expat}
    --with-z=${zlib}
    --enable-mods-shared=all
    --enable-authn-alias
    ${if proxySupport then "--enable-proxy" else ""}
    --without-gdbm
    --enable-threads
    --with-devrandom=/dev/urandom
    ${if sslSupport then "--enable-ssl --with-ssl=${openssl}" else ""}
    ${if db4Support then "--with-berkeley-db=${db4}" else ""}
  '';

  postInstall = ''
    echo "removing manual"
    rm -rf $out/manual
  '';

  # For now, disable detection of epoll to ensure that Apache still
  # runs on Linux 2.4 kernels.  Once we've dropped support for 2.4 in
  # Nixpkgs, this can go.  In general, it's a problem that APR
  # detects characteristics of the build system's kernel to decide
  # what to use at runtime, since it's impure.
  apr_cv_epoll = "no";

  passthru = {
    inherit expat sslSupport db4Support proxySupport;
  };
  
  meta = {
    description = "Apache HTTPD, the world's most popular web server";
    homepage = http://httpd.apache.org/;
  };
}
