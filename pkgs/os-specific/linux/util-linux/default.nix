{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "util-linux-2.12r";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/util-linux-2.12r.tar.bz2;
    md5 = "af9d9e03038481fbf79ea3ac33f116f9";
  };
  patches = [./MCONFIG.patch];
}
