{ cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-ghci";
  version = "0.2.1";
  sha256 = "0za0bf59f4a3v5zvyy7h1xvxskrazdga4j1cs6psfv9fv80qig9r";
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
