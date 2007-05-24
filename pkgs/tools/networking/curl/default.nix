{stdenv, fetchurl, zlibSupport ? false, zlib, sslSupport ? false, openssl ? null}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.16.2";
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.16.2.tar.bz2;
    sha256 = "18mzp56y8qhlvi27av7866mvsiyiigb7c5qdppjr8qizsj0kx0rf";
  };
  buildInputs =
    stdenv.lib.optional zlibSupport zlib ++
    stdenv.lib.optional sslSupport openssl;
  configureFlags = "
    ${if sslSupport then "--with-ssl=${openssl}" else "--without-ssl"}
  ";
  CFLAGS = if stdenv ? isDietLibC then "-DHAVE_INET_NTOA_R_2_ARGS=1" else "";
  CXX = "g++";
  CXXCPP = "g++ -E";
  inherit sslSupport openssl;
}
