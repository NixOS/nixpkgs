{cabal, perl}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "2.3.5"; # Haskell Platform 2011.2.0.0
  name = self.fname;
  sha256 = "0lyjiq4lmii2syk6838ln32qvn8c0ljf1ypsggahy748k05x79if";
  extraBuildInputs = [perl];
  meta = {
    description = "A lexical analyser generator for Haskell";
  };
})
