{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "gnum4-1.4.7";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/m4-1.4.7.tar.bz2;
    md5 = "0115a354217e36ca396ad258f6749f51";
  };
}
