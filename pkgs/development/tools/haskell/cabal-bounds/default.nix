{ cabal, Cabal, cabalLenses, cmdargs, either, filepath, lens
, strict, tasty, tastyGolden, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "cabal-bounds";
  version = "0.6";
  sha256 = "0dl8rf8y365a20yz5kk1c9y860k5mkg1jp5dipvbf451h7a7h9w5";
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
