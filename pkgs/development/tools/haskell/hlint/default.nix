{ cabal, cpphs, haskellSrcExts, hscolour, transformers, uniplate }:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.16";
  sha256 = "0crahq7fvhf0qvjcpjnmv5yh29l52cv7rgfwrc6ka4q0dm9r49vb";
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
