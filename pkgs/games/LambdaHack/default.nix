{ cabal, binary, ConfigFile, gtk, MissingH, mtl, random, zlib }:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.1.20110918";
  sha256 = "14zn650x7r65lb76hygz6yiwzbg2rbcyisi7kx2lszrbg0fp8pa9";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ binary ConfigFile gtk MissingH mtl random zlib ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
