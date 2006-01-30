{stdenv, fetchurl}:

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "dietlibc-0.29";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/dietlibc-0.29.tar.bz2;
    md5 = "16d31dd7b5f9124e8ea8280c3f646e13";
  };
  patches = [./dietlibc-install.patch];
}
