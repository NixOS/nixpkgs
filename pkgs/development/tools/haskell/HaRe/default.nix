{ cabal, deepseq, Diff, dualTree, filepath, ghcMod, ghcPaths
, ghcSybUtils, haskellTokenUtils, hslogger, hspec, HUnit
, monoidExtras, mtl, parsec, QuickCheck, rosezipper, semigroups
, silently, StrafunskiStrategyLib, stringbuilder, syb, syz, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.2.4";
  sha256 = "1ljyvs3mdgxzyvss071yvgnrnmhdyp9a10cmvij1d47li1wbj1j1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dualTree filepath ghcMod ghcPaths ghcSybUtils haskellTokenUtils
    hslogger monoidExtras mtl parsec rosezipper semigroups
    StrafunskiStrategyLib syb syz time transformers
  ];
  testDepends = [
    deepseq Diff dualTree filepath ghcMod ghcPaths ghcSybUtils
    haskellTokenUtils hslogger hspec HUnit monoidExtras mtl QuickCheck
    rosezipper semigroups silently StrafunskiStrategyLib stringbuilder
    syb syz time transformers
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
