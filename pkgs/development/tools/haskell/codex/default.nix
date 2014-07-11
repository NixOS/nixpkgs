{ cabal, Cabal, downloadCurl, either, filepath, hackageDb, MissingH
, monadLoops, tar, text, transformers, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "codex";
  version = "0.1.0.1";
  sha256 = "1s2sn2i0ah4wgyzz5vqkm65jkl3c38cwa2kp0az4xl3vb8y6x7la";
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
