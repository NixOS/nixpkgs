{ cabal, cmdtheline, deepseq, Diff, filepath, ghcMod, ghcPaths
, ghcSybUtils, hslogger, hspec, HUnit, mtl, parsec, QuickCheck
, rosezipper, silently, StrafunskiStrategyLib, stringbuilder, syb
, syz, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.7.0.7";
  sha256 = "0pgl5mav4sqc453by7nddf5fz7nj231072bklzj6crcph7qw4zy4";
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
