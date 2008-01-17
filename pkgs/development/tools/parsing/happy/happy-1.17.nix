{stdenv, fetchurl, perl, ghc}:

stdenv.mkDerivation (rec {

  # requires cabal-1.2 (and therefore, in Nix, currently ghc-6.8)

  pname = "happy";
  version = "1.17";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "http://www.haskell.org/happy/dist/${version}/${name}.tar.gz";
    sha256 = "dca4e47d17e5d538335496236b3d2c3cbff644cf7380c987a4714e7784c70a2b";
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
})
