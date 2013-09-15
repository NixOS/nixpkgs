{ cabal, cmdtheline, deepseq, Diff, filepath, ghcMod, ghcPaths
, ghcSybUtils, hslogger, hspec, HUnit, mtl, parsec, QuickCheck
, rosezipper, silently, StrafunskiStrategyLib, stringbuilder, syb
, syz, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.0.4";
  sha256 = "0h34bqiig4d7xk514gl0zk119xbl2i3x5h2hvylbrzq1mrdc6xnk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdtheline filepath ghcMod ghcPaths ghcSybUtils hslogger mtl parsec
    rosezipper StrafunskiStrategyLib syb syz time transformers
  ];
  testDepends = [
    deepseq Diff filepath ghcMod ghcPaths ghcSybUtils hslogger hspec
    HUnit mtl QuickCheck rosezipper silently StrafunskiStrategyLib
    stringbuilder syb syz time transformers
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
