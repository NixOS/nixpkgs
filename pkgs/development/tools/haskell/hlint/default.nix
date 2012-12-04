{ cabal, cpphs, filepath, haskellSrcExts, hscolour, transformers
, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.37";
  sha256 = "00d971r6775rf8lb0psz0n1zxjzgf7114zf1hj7ll2ylxxdn5wwl";
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
