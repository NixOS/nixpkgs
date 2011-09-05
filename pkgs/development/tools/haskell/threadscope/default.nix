{ cabal, binary, cairo, ghcEvents, glib, gtk, mtl, pango }:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.2.0";
  sha256 = "0b8lc8han4d90wgzliy80l1gbkm09gg6qxsn37blj41wzl6yzr9k";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ binary cairo ghcEvents glib gtk mtl pango ];
  configureFlags = "--ghc-options=-rtsopts";
  meta = {
    description = "A graphical tool for profiling parallel Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
