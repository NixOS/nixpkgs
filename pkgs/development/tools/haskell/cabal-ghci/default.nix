{ cabal }:

cabal.mkDerivation (self: {
  pname = "cabal-ghci";
  version = "0.1.1";
  sha256 = "09r66fv8ncsdj90zrhg4srxhmbhmf7q61kvfc39x4jbyskgciqms";
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
