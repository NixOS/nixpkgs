{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null, dietgcc}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.15.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/curl-7.15.5.tar.bz2;
    md5 = "594142c7d53bbdd988e8cef6354eeeff";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  configureFlags = "--enable-shared=no" + (if sslSupport then "--with-ssl" else "--without-ssl");
  NIX_GCC = dietgcc;
  NIX_GLIBC_FLAGS_SET=1;
  NIX_CFLAGS_COMPILE="-D_BSD_SOURCE=1 -DHAVE_INET_NTOA_R_2_ARGS=1";
}
