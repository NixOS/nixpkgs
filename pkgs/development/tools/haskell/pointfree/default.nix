{ cabal, haskellSrcExts, HUnit, QuickCheck, transformers }:

cabal.mkDerivation (self: {
  pname = "pointfree";
  version = "1.0.4.7";
  sha256 = "0jwql0ka01cr53ayjc4dpaci11i7r1y3b9gcbh3rlamb1mnfcqvl";
  isLibrary = false;
  isExecutable = true;
  jailbreak = true;
  buildDepends = [ haskellSrcExts transformers ];
  testDepends = [ haskellSrcExts HUnit QuickCheck transformers ];
  meta = {
    description = "Tool for refactoring expressions into pointfree form";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
