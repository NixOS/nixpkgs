{ cabal, binary, ConfigFile, deepseq, enummapset, filepath, gtk
, hashable, keys, miniutter, mtl, prettyShow, random, stm, text
, transformers, unorderedContainers, zlib
}:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.10";
  sha256 = "1lj960r6gyg8kpc13fs6yq51l0qkpk4yd7ixhh0j4j8xghvx9mw5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary ConfigFile deepseq enummapset filepath gtk hashable keys
    miniutter mtl prettyShow random stm text transformers
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
