{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.15.5";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/curl-7.15.5.tar.bz2;
    md5 = "594142c7d53bbdd988e8cef6354eeeff";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  inherit sslSupport openssl;
}
