{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "util-linux-2.12q";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.kernel.org/pub/linux/utils/util-linux/util-linux-2.12q.tar.bz2;
    md5 = "54320aa1abbce00c0dc030e2c3afe5d7";
  };
  patches = [./MCONFIG.patch];
}
