{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "strace-4.5.6";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/strace-4.5.6.tar.bz2;
    md5 = "2dd9d23430957a7ee0221efb28c66d1e";
  };
}
