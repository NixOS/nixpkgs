{ cabal, cmdargs, cpphs, filepath, haskellSrcExts, hscolour
, transformers, uniplate
}:

cabal.mkDerivation (self: {
  pname = "hlint";
  version = "1.9";
  sha256 = "1c8qpfrivsxx6raqnrz40li73hng4z0ygc1hl70qixbmsmv2a830";
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
