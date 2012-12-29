{ cabal, bytestringLexing, cairo, Chart, colour, HUnit, mtl
, strptime, time, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "splot";
  version = "0.3.7";
  sha256 = "0mal7zphwzycxm2i0v87vn6gvdb582zy51prngj4w11xgpxd7dg1";
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
