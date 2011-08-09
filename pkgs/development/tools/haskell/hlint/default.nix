{ cabal, cpphs, haskellSrcExts, hscolour, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.13";
  sha256 = "125hvljx70b1zai3xdrarjl9fji2fq2g390rlffq428ifjrl9nk2";
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
