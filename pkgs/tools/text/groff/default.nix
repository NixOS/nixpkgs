{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "groff-1.19.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/groff-1.19.1.tar.gz;
    md5 = "57d155378640c12a80642664dfdfc892";
  };
}
