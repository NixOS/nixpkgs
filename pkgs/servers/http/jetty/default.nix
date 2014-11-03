{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "jetty-5.1.4";

  builder = ./bin-builder.sh;
  buildInputs = [unzip];

  src = fetchurl {
    url = mirror://sourceforge/jetty/jetty-5.1.4.zip;
    sha256 = "1lzvsrlybrf3zzzv4hi2v82qzpkfkib3xbwwlya8c08gf0360mrk";
  };
}
