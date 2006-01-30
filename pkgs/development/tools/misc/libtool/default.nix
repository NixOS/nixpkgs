{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation {
  name = "libtool-1.5.20";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libtool-1.5.20.tar.gz;
    md5 = "fc3b564700aebcb19de841c1c2d66e99";
  };
  buildInputs = [m4 perl];
}
