{stdenv, fetchurl, noSysDirs}:

stdenv.mkDerivation {
  name = "binutils-2.17";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/binutils-2.17.tar.bz2;
    md5 = "e26e2e06b6e4bf3acf1dc8688a94c0d1";
  };
  inherit noSysDirs;
}
