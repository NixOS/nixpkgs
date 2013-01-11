{ cabal, bytestringLexing, cairo, Chart, colour, HUnit, mtl
, strptime, time, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "splot";
  version = "0.3.8";
  sha256 = "188v9c070wn6gr47k5q55gsiph0lj96d96bss76gz7znknfj9rm3";
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
