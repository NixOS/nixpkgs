{ cabal, attoparsec, deepseq, filepath, haskellSrcMeta
, languageJavascript, mimeTypes, monadloc, mtl, optparseApplicative
, syb, systemFilepath, text, textFormat
}:

cabal.mkDerivation (self: {
  pname = "cake3";
  version = "0.5.0.0";
  sha256 = "0hfnda0xp8saav85pgqmcb6ib699gm6gy5f087nlrx7058f4n7ji";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec deepseq filepath haskellSrcMeta languageJavascript
    mimeTypes monadloc mtl optparseApplicative syb systemFilepath text
    textFormat
  ];
  meta = {
    homepage = "https://github.com/grwlf/cake3";
    description = "Third cake the Makefile EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
