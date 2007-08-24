{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "sysklogd-1.4.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.4.1.tar.gz;
    md5 = "d214aa40beabf7bdb0c9b3c64432c774";
  };
  patches = [./sysklogd-1.4.1-cvs-20050525-local.diff ./sysklogd-1.4.1-asm.patch];
}
