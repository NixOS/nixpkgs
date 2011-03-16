{cabal, mtl, perl}:

cabal.mkDerivation (self : {
  pname = "happy";
  version = "1.18.5"; # Haskell Platform 2010.2.0.0
  name = self.fname;
  sha256 = "91e1c29ac42bc5cabcac2c2e28e693fc59fbdf30636e5c52cb51b779a74d755e";
  extraBuildInputs = [perl];
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Happy is a parser generator for Haskell";
  };
})
