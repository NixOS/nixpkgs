{ cabal, cpphs, filepath, haskellSrcExts, hscolour, transformers
, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.43";
  sha256 = "0wffswyx60qig1is3ki5asp8i4wvd3gqg2r811rw0zxwi3nrjiv6";
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
