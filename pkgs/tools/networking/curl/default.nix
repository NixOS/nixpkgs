{stdenv, fetchurl, zlib}:

stdenv.mkDerivation {
  name = "curl-7.11.1";
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.11.1.tar.bz2;
    md5 = "c2af7c3364a1a8839516f74961b6bd11";
  };
  buildInputs = [zlib];
  configureFlags = "--without-ssl";
}
