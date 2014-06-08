{ cabal, Cabal, cabalLenses, cmdargs, either, filepath, lens
, strict, tasty, tastyGolden, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cabal-bounds";
  version = "0.5";
  sha256 = "0sx6vyf3p62khg7qv7nwgd8fns6dsfpw34gpl7zmb6n0c1kjj60b";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal cabalLenses cmdargs either lens strict transformers
    unorderedContainers
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
