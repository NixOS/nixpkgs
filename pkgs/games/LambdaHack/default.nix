{ cabal, assertFailure, binary, deepseq, enummapsetTh, filepath
, gtk, hashable, hsini, keys, miniutter, mtl, prettyShow, random
, stm, text, transformers, unorderedContainers, vector
, vectorBinaryInstances, zlib
}:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.12";
  sha256 = "0ics1z376qyagkzg58mqqw7cbkjpkik57l8570qmk589nkhck86n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    assertFailure binary deepseq enummapsetTh filepath gtk hashable
    hsini keys miniutter mtl prettyShow random stm text transformers
    unorderedContainers vector vectorBinaryInstances zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
