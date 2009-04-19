{cabal, mtl, perl}:

cabal.mkDerivation (self : {
  pname = "happy";
  version = "1.18.2"; # Haskell Platform 2009.0.0
  name = self.fname;
  sha256 = "7515922f3cfd32cd844a0abfefe0b4871f403f0d869b8644bf9cbfc0b67996ae";
  extraBuildInputs = [perl];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Happy is a parser generator for Haskell";
  };
})
