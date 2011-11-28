{ cabal, cpphs, haskellSrcExts, hscolour, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.19";
  sha256 = "0nbj5nkwmiadkp7h8nbx2xg79mvgd97hm9wk0nmfv9ncwnkz9xcc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cpphs haskellSrcExts hscolour transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
