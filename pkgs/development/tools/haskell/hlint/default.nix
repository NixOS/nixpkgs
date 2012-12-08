{ cabal, cpphs, filepath, haskellSrcExts, hscolour, transformers
, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.39";
  sha256 = "009qf441nri8pxzz22xvpz44dhspr9bkh5diaz29abimj10fm375";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cpphs filepath haskellSrcExts hscolour transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
