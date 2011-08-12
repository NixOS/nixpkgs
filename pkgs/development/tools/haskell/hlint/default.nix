{ cabal, cpphs, haskellSrcExts, hscolour, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.14";
  sha256 = "16gjn404ar6i9cn1fyj6yqdr4qbpswwa6w2k06bbjqcnca8l9gin";
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
