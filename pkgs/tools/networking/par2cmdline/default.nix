{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "par2cmdline-0.4";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/par2cmdline-0.4.tar.gz;
    md5 = "1551b63e57e3c232254dc62073b723a9";
  };
}
