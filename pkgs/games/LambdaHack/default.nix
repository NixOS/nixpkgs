{ cabal, assertFailure, binary, ConfigFile, deepseq, enummapsetTh
, filepath, gtk, hashable, keys, miniutter, mtl, prettyShow, random
, stm, text, transformers, unorderedContainers, zlib
}:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.10.5";
  sha256 = "0a10xchhqh61idqb7ycassvy6gmprz9820w0z3r33h1c9sldq1lk";
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
