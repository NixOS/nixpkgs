{stdenv, fetchurl, zlib}:

derivation {
  name = "curl-7.11.1";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://curl.haxx.se/download/curl-7.11.1.tar.bz2;
    md5 = "c2af7c3364a1a8839516f74961b6bd11";
  };
  buildInputs = [zlib];
  inherit stdenv;
}
