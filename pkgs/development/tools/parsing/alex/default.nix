{cabal, perl}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "2.3.1"; # Haskell Platform 2009.0.0
  name = self.fname;
  sha256 = "cdd42fd992a72fedeff1f38debc21aa315d90dc070f0945d7819c0bccd549a44";
  extraBuildInputs = [perl];
  meta = {
    description = "A lexical analyser generator for Haskell";
  };
})
