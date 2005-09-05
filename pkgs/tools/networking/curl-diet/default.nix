{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null, dietgcc}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.14.1";
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.14.1.tar.bz2;
    md5 = "8b8723f3c0e7acfb30c5215e6cffde32";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  #configureFlags = (if sslSupport then "--with-ssl" else "--without-ssl");
  configureFlags = "--enable-shared=no" + (if sslSupport then "--with-ssl" else "--without-ssl");
  NIX_GCC = dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1 -DHAVE_INET_NTOA_R_2_ARGS=1";
}
