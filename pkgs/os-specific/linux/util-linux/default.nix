{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "util-linux-2.12q";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/util-linux-2.12q.tar.bz2;
    md5 = "54320aa1abbce00c0dc030e2c3afe5d7";
  };
  patches = [./MCONFIG.patch];
}
