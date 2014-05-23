{ cabal, Cabal, downloadCurl, either, filepath, hackageDb, MissingH
, monadLoops, tar, text, transformers, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "codex";
  version = "0.0.2";
  sha256 = "156830krsn1qczrx27bn3ihqlis698sjf563sa2njvc7v85plx55";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal downloadCurl either filepath hackageDb MissingH monadLoops
    tar text transformers yaml zlib
  ];
  meta = {
    homepage = "http://github.com/aloiscochard/codex";
    description = "A ctags file generator for cabal project dependencies";
    license = self.stdenv.lib.licenses.asl20;
    platforms = self.ghc.meta.platforms;
  };
})
