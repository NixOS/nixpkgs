{ cabal, cpphs, haskellSrcExts, hscolour, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.15";
  sha256 = "1hi2qapi8lb7cawjzvpknp8qvsnfw3glxyyd5m2lbp3rvkx0d6kr";
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
