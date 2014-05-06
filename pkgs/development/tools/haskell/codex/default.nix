{ cabal, Cabal_1_20_0_0, downloadCurl, either, filepath, hackageDb, MissingH
, monadLoops, tar, text, transformers, yaml, zlib
}:

cabal.mkDerivation (self: {
  pname = "codex";
  version = "0.0.1.6";
  sha256 = "0yr3qygxxj4k8ld7jh1h87jjawvixbz5wjssdxd5ix7askmm1dx2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal_1_20_0_0 downloadCurl either filepath hackageDb MissingH 
    monadLoops tar text transformers yaml zlib
  ];
  meta = {
    homepage = "http://github.com/aloiscochard/codex";
    description = "A ctags file generator for cabal project dependencies";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
