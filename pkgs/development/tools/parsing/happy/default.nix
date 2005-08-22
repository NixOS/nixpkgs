{stdenv, fetchurl, perl, ghc}:

stdenv.mkDerivation {
  name = "happy-1.14";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/happy-1.14-src.tar.gz;
    md5 = "501b5b63533b2e2838de18085e8c4492";
  };
  buildInputs = [ghc perl];
}
