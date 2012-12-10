{ cabal, binary, ConfigFile, filepath, gtk, mtl, random, zlib }:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.6";
  sha256 = "03adjwzbql1k1ky05vivry7waa8p41ha3lsnv9j9mdgpwqldypwd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ConfigFile filepath gtk mtl random zlib ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
