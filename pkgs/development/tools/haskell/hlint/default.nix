{ cabal, cmdargs, cpphs, filepath, haskellSrcExts, hscolour
, transformers, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.8.61";
  sha256 = "08y8ny6dv14gxnzzr5f1hvs22m7y62yffyq2pzvw2aja8fbj5d2z";
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
