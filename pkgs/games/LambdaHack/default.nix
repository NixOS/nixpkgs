{ cabal, assertFailure, binary, ConfigFile, deepseq, enummapsetTh
, filepath, gtk, hashable, keys, miniutter, mtl, prettyShow, random
, stm, text, transformers, unorderedContainers, zlib
}:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.10.6";
  sha256 = "19ak0ygw38b51wkm4p10xgdk3h9mh5vvb8c60qhs7cmgzjcph38n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    assertFailure binary ConfigFile deepseq enummapsetTh filepath gtk
    hashable keys miniutter mtl prettyShow random stm text transformers
    unorderedContainers zlib
  ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
