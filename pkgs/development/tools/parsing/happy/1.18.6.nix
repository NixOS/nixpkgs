{cabal, mtl, perl}:

cabal.mkDerivation (self : {
  pname = "happy";
  version = "1.18.6"; # Haskell Platform 2011.2.0.0
  name = self.fname;
  sha256 = "0q6dnwihi1q761qdq0hhi733nh5d53xz6frwmr7slpvrp6v8y344";
  extraBuildInputs = [perl];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Happy is a parser generator for Haskell";
  };
})
