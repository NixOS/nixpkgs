{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "elfutils-0.127";
  src = fetchurl {
    url = http://ftp.cs.pu.edu.tw/Linux/sourceware/systemtap/elfutils/elfutils-0.127.tar.gz;
    sha256 = "12n3h5r3c24a6l2wxz0w2dqq072bvgms0dzckivrwp5vdn22lpdv";
  };
}
