{cabal, ghcPaths, alex, happy}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "2.7.2"; # Haskell Platform 2010.1.0.0 and 2010.2.0.0
  name = self.fname;
  sha256 = "4eaaaf62785f0ba3d37ba356cfac4679faef91c0902d8cdbf42837cbe5daab82";
  extraBuildInputs = [alex happy];
  propagatedBuildInputs = [ghcPaths];
  meta = {
    description = "a tool for automatically generating documentation from annotated Haskell source code";
  };
})
