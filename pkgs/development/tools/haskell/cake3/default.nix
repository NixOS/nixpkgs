{ cabal, attoparsec, deepseq, filepath, haskellSrcMeta
, languageJavascript, mimeTypes, monadloc, mtl, optparseApplicative
, parsec, syb, systemFilepath, text, textFormat
}:

cabal.mkDerivation (self: {
  pname = "cake3";
  version = "0.5.1.0";
  sha256 = "0kqx8xr0ynbn7fhfz11is7lbi32dfladsx32bcpspykqj1bjv954";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec deepseq filepath haskellSrcMeta languageJavascript
    mimeTypes monadloc mtl optparseApplicative parsec syb
    systemFilepath text textFormat
  ];
  meta = {
    homepage = "https://github.com/grwlf/cake3";
    description = "Third cake the Makefile EDSL";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
