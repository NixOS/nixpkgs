{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, hslogger, hspec, HUnit, monoidExtras, mtl, parsec
, QuickCheck, rosezipper, semigroups, silently
, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.2.0";
  sha256 = "0i769mryjr3v9vh4zkdycpha8skq9xcdln3plrxx55bf42c4aqi9";
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
