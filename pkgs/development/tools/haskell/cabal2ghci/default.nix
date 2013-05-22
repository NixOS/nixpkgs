{ cabal, Cabal, cmdargs, stylishHaskell, systemFileio
, systemFilepath, text, unorderedContainers, yaml
}:

cabal.mkDerivation (self: {
  pname = "cabal2ghci";
  version = "0.0.1.0";
  sha256 = "0l5225gwm6j25694cp94d4z31i1p68pq6js3psbr7m204q409dr5";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal cmdargs stylishHaskell systemFileio systemFilepath text
    unorderedContainers yaml
  ];
  meta = {
    description = "A tool to generate .ghci file from .cabal";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
