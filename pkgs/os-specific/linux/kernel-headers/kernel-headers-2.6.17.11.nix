{stdenv, fetchurl}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "linux-headers-2.6.17.11";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/linux-2.6.17.11.tar.bz2;
    md5 = "2958a620129c442a8ba3a665ea34ca8b";
  };
}
