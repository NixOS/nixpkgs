{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "bsdiff-4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/bsdiff-4.2.tar.gz;
    md5 = "9f582a77eb76d116d82d1ad268ef48fa";
  };
  patches = [./makefile.patch];
}
