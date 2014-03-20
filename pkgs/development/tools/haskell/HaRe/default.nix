{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, hslogger, hspec, HUnit, monoidExtras, mtl, parsec
, QuickCheck, rosezipper, semigroups, silently
, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.1.6";
  sha256 = "1nj70f7ki6wxvjm5ra83xr2yymfsakb5kg2q1dl54hvxsd0wqcw7";
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
    homepage = "https://github.com/RefactoringTools/HaRe/wiki";
    description = "the Haskell Refactorer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
