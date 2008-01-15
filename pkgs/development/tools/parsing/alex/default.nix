{stdenv, fetchurl, ghc, perl}:

stdenv.mkDerivation {
  name = "alex-2.1.0";
  src = fetchurl {
    url = http://www.haskell.org/alex/dist/2.1.0/alex-2.1.0.tar.gz;
    sha1 = "37599b7be5249d639b3a5a3fdc61907dc4dad660";
  };
  buildInputs = [ghc perl];

  configurePhase = "
    ghc --make Setup.lhs
    ./Setup configure --prefix=\"\${out}\"
  ";

  buildPhase = "
    ./Setup build
  ";

  installPhase = "
    ./Setup install
  ";
}
