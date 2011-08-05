{cabal, perl, QuickCheck2}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "3.0"; # Haskell Platform future?
  name = self.fname;
  sha256 = "0vjm58xb64lvhd7h3cfgrm81630pl2avz6v98323s6i9jsizi8js";
  extraBuildInputs = [perl QuickCheck2];
  meta = {
    description = "A lexical analyser generator for Haskell";
  };
})
