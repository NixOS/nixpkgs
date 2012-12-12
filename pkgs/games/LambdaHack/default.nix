{ cabal, binary, ConfigFile, filepath, gtk, miniutter, mtl, random
, text, zlib
}:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.6.5";
  sha256 = "114s3adqs5mh566dbn0bb20v088wgg8arsm6m8hs9vx8j3jc8nx5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary ConfigFile filepath gtk miniutter mtl random text zlib
  ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
