{ cabal, hint, mtl, network, syb }:

cabal.mkDerivation (self: {
  pname = "HaRe";
  version = "0.6.0.1";
  sha256 = "cd3fa312c7fa6a5f761bbc3ebdbc6300e83ba9e285047acded6269d2164d67f8";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ hint mtl network syb ];
  meta = {
    homepage = "http://www.cs.kent.ac.uk/projects/refactor-fp";
    description = "the Haskell Refactorer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
