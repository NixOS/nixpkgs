{ cabal, ansiWlPprint, Cabal, filepath, mtl, optparseApplicative
, tar, utf8String
}:

cabal.mkDerivation (self: {
  pname = "cabal-db";
  version = "0.1.9";
  sha256 = "19mw5ycc2y5wkn1h7wkdm2gb29pq2sh0n8z52dbxlkf0rwcgjbfq";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    ansiWlPprint Cabal filepath mtl optparseApplicative tar utf8String
  ];
  meta = {
    homepage = "http://github.com/vincenthz/cabal-db";
    description = "query tools for the local cabal database (revdeps, graph, info, search-by, license, bounds)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
