{ cabal, bytestringLexing, cairo, Chart, colour, HUnit, mtl
, strptime, time, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "splot";
  version = "0.3.9";
  sha256 = "039k6lgwdvpyc8w74zh98wxi1wj2jmin69jnwp7gnmv43kjpbgh5";
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
