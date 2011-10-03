{ cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-ghci";
  version = "0.2.0";
  sha256 = "0920q103g626f8syvn73bwqnix8x6q58xyazys6yinhr7dgi2x6m";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://code.atnnn.com/projects/cabal-ghci/wiki";
    description = "Set up ghci with options taken from a .cabal file";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
