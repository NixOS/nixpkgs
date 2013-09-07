{ cabal, bytestringLexing, cairo, colour, HUnit, mtl
, strptime, time, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "splot";
  version = "0.3.11";
  sha256 = "0mpyfmafjjcf85v740h69p5mggyqsq3li8m1fa5c0z4rdd0395an";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    bytestringLexing cairo colour HUnit mtl strptime time
    vcsRevision
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Splot";
    description = "A tool for visualizing the lifecycle of many concurrent multi-staged processes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
