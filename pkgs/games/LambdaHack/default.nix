{ cabal, binary, ConfigFile, filepath, gtk, mtl, random, zlib }:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.1";
  sha256 = "1d2mnpy8fl9m5584rbskgary18mqibivwmlz9gfv87gg0lzhw2ab";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ConfigFile filepath gtk mtl random zlib ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and very active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
