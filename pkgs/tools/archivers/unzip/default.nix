{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "unzip-5.52";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/unzip552.tar.gz;
    md5 = "9d23919999d6eac9217d1f41472034a9";
  };
}
