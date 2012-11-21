{ cabal, bytestringLexing, cairo, Chart, colour, HUnit, mtl
, strptime, time, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "splot";
  version = "0.3.6";
  sha256 = "0fxjji6b0v3hf4pn1cbh88nvp4n4bfgfkiga6l149flk5nmlapqx";
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
