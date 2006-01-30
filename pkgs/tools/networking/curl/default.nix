{stdenv, fetchurl, zlib, sslSupport ? false, openssl ? null}:

assert sslSupport -> openssl != null;

stdenv.mkDerivation {
  name = "curl-7.15.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/curl-7.15.1.tar.bz2;
    md5 = "d330d48580bfade58c82d4f295f171f0";
  };
  buildInputs = [zlib (if sslSupport then openssl else null)];
  patches = [./configure-cxxcpp.patch];
  configureFlags = (if sslSupport then "--with-ssl" else "--without-ssl");
}
