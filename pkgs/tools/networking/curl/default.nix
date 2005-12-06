{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.15.0";
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.15.0.tar.bz2;
    md5 = "e3b130320d3704af375c097606f49c01";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  configureFlags = (if sslSupport then "--with-ssl" else "--without-ssl");
}
