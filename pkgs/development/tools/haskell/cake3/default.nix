{ cabal, attoparsec, deepseq, filepath, haskellSrcMeta
, languageJavascript, mimeTypes, monadloc, mtl, optparseApplicative
, syb, systemFilepath, text, textFormat
}:

cabal.mkDerivation (self: {
  pname = "cake3";
  version = "0.4.0.0";
  sha256 = "15v50m60fr2mgfm2irxfaw4pi2s3bx187p0y0ns20rqfy0dasxyx";
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
