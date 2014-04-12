{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, hslogger, hspec, HUnit, monoidExtras, mtl, parsec
, QuickCheck, rosezipper, semigroups, silently
, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.2.2";
  sha256 = "0w9cjs3r99k4mf835higcsllk0h8lbich1v9wb2pvwbqi3i9r0sp";
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
