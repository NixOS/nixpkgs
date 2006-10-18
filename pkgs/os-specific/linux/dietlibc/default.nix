{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "dietlibc-0.30";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/dietlibc-0.30.tar.bz2;
    md5 = "2465d652fff6f1fad3da3b98e60e83c9";
  };
  builder = ./builder.sh;
#  patches = [./dietlibc-install.patch];
}
