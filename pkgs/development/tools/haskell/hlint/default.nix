{ cabal, cmdargs, cpphs, filepath, haskellSrcExts, hscolour
, transformers, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.59";
  sha256 = "14yn63zbbqwvxlis0kwga4mrz6qjr8kq1cq7f0rcilgqgh1dkwh8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs cpphs filepath haskellSrcExts hscolour transformers
    uniplate
  ];
  jailbreak = true;
  meta = {
    homepage = "http://community.haskell.org/~ndm/hlint/";
    description = "Source code suggestions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
