{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cksfv-1.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/cksfv-1.3.tar.gz;
    md5 = "e00cf6a80a566539eb6f3432f2282c38";
  };
}
