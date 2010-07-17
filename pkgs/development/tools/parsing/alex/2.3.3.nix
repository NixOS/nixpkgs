{cabal, perl}:

cabal.mkDerivation (self : {
  pname = "alex";
  version = "2.3.3"; # Haskell Platform 2010.2.0.0
  name = self.fname;
  sha256 = "338fc492a1fddd6c528d0eb89857cadab211cb42680aeee1f9702bbfa7c5e1c8";
  extraBuildInputs = [perl];
  meta = {
    description = "A lexical analyser generator for Haskell";
  };
})
