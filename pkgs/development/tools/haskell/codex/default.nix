{ cabal, Cabal, downloadCurl, either, filepath, hackageDb, MissingH
, monadLoops, tar, text, transformers, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "codex";
  version = "0.1.0.0";
  sha256 = "00h2gbb20a1p2qfy6nddyrjipnx0p6xdh0f56z298rw7ssrzvzag";
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
