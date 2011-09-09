{ cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-ghci";
  version = "0.1";
  sha256 = "05xyd3xl238pi5vq392m62p4vdf1n8wwxvbi05bh8hamqrkd3j8p";
  isLibrary = true;
  isExecutable = true;
  noHaddock = true;
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
