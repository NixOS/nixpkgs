{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.14.0";
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.14.0.tar.bz2;
    md5 = "46ce665e47d37fce1a0bad935cce58a9";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  configureFlags = (if sslSupport then "--with-ssl" else "--without-ssl");
}
