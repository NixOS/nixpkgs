{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, hslogger, hspec, HUnit, monoidExtras, mtl, parsec
, QuickCheck, rosezipper, semigroups, silently
, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.0.9";
  sha256 = "1a3kf6hdzchcyb743l6ikyw3nclcy8g7a5kaj4jgxqvmss9z73f1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dualTree filepath ghcMod ghcPaths ghcSybUtils hslogger monoidExtras
    mtl parsec rosezipper semigroups StrafunskiStrategyLib syb syz time
    transformers
  ];
  testDepends = [
    deepseq Diff dualTree filepath ghcMod ghcPaths ghcSybUtils hslogger
    hspec HUnit monoidExtras mtl QuickCheck rosezipper semigroups
    silently StrafunskiStrategyLib stringbuilder syb syz time
    transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.cs.kent.ac.uk/projects/refactor-fp";
    description = "the Haskell Refactorer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
