{ cabal, bytestringLexing, cairo, Chart, colour, HUnit, mtl
, strptime, time, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "splot";
  version = "0.3.4";
  sha256 = "1qfi8vqm4zliz0lmi6njicm8xha6w8w55il09k0d1w5akwi93x5j";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    bytestringLexing cairo Chart colour HUnit mtl strptime time
    vcsRevision
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Splot";
    description = "A tool for visualizing the lifecycle of many concurrent multi-staged processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
