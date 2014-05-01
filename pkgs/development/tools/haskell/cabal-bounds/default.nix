{ cabal, Cabal, cmdargs, either, filepath, lens, strict, tasty
, tastyGolden, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cabal-bounds";
  version = "0.4.1";
  sha256 = "09l9ii26li178sw0rm49w4dhfkf46g4sjjdy4frmc74isvnzkpwj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal cmdargs either lens strict transformers unorderedContainers
  ];
  testDepends = [ filepath tasty tastyGolden ];
  jailbreak = true;
  doCheck = false;
  meta = {
    description = "A command line program for managing the bounds/versions of the dependencies in a cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
