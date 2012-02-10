{ cabal, binary, ConfigFile, gtk, mtl, random, zlib }:

cabal.mkDerivation (self: {
  pname = "LambdaHack";
  version = "0.2.0";
  sha256 = "09lgbpwrlw29n797q3k5aafvkg04nd8cw6pi41g914phf7lxzq4c";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary ConfigFile gtk mtl random zlib ];
  meta = {
    homepage = "http://github.com/kosmikus/LambdaHack";
    description = "A roguelike game engine in early and very active development";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
