{stdenv, fetchurl, expat} :

stdenv.mkDerivation {
  name = "sablotron-1.0.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/Sablot-1.0.2.tar.gz;
    md5 = "12243bc21b149cad89e98bc89f9c103e";
  };
  buildInputs = [expat];
}
