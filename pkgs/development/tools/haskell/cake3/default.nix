{ cabal, attoparsec, deepseq, filepath, haskellSrcMeta
, languageJavascript, mimeTypes, monadloc, mtl, optparseApplicative
, syb, systemFilepath, text, textFormat
}:

cabal.mkDerivation (self: {
  pname = "cake3";
  version = "0.3.0.1";
  sha256 = "0s91kgfh6y14m60na7bsr41gzd573vra5c0mgp1a3pzngsj0cvhm";
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
