{ cabal, Cabal, cpphs, filepath, haskellSrcExts, hscolour
, transformers, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.23";
  sha256 = "0cbjnzs9ddk4z7kxh935x1kvr566afcvk98z3174f3xp5sbz79wr";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal cpphs filepath haskellSrcExts hscolour transformers uniplate
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
