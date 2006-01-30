{stdenv, fetchurl, kernel, perl, bison, flexWrapper}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "klibc-1.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/klibc-1.0.tar.bz2;
    md5 = "daaa233fb7905cbe110896fcad9bec7f";
  };
  inherit kernel;
  buildInputs = [perl bison flexWrapper];
  patches = [./klibc-installpath.patch];
}
