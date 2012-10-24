{ cabal, cpphs, filepath, haskellSrcExts, hscolour, transformers
, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.33";
  sha256 = "1n1kcd99226f8cwx3zmjv0fh1xk2k0y490l6p2fa9m0av835brr7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cpphs filepath haskellSrcExts hscolour transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
