{ cabal, binary, cairo, ghcEvents, glade, gtk, mtl }:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.1.3";
  sha256 = "1vak3624vrnkfvwxzfw5hkc0552v213jb874f6q536g5vhjjxpih";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ binary cairo ghcEvents glade gtk mtl ];
  configureFlags = "--ghc-options=-rtsopts";
  meta = {
    description = "A graphical thread profiler";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
