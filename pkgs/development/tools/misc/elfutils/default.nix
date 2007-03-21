{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "elfutils-0.125";
  src = fetchurl {
    url = http://ftp.cs.pu.edu.tw/Linux/sourceware/systemtap/elfutils/elfutils-0.125.tar.gz;
    sha256 = "191n7ss9hbhgm5q6ak2bdiwmid8ls1ivn30hl18a5d6bqal50529";
  };
}
