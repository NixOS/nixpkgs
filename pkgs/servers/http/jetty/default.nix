{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "jetty-4.2.22";

  builder = ./bin-builder.sh;

  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/jetty-4.2.22.tar.gz;
    md5 = "e89c582d1846cd7d31e402abaf801e17";
  };
}
