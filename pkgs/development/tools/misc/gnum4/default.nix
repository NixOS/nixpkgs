{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/m4-1.4.tar.gz;
    md5 = "9eb2dd07740b2d2f3c7adb3e8d299bda";
  };
}
