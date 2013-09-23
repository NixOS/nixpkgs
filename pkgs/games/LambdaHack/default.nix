{ cabal, binary, ConfigFile, deepseq, enummapset, filepath, gtk
, hashable, keys, miniutter, mtl, random, stm, text, transformers
, unorderedContainers, zlib
}:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.8";
  sha256 = "0dwv6ljigwc46czyivn4ivszfiykvhjx6n4agv7lwx8faan7kax3";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary ConfigFile deepseq enummapset filepath gtk hashable keys
    miniutter mtl random stm text transformers unorderedContainers zlib
  ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
