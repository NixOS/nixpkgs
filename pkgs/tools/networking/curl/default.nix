{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.15.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.15.4.tar.bz2;
    md5 = "d9345a55c8bc67eafcd37fa1b728e00e";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  inherit sslSupport openssl;
}
