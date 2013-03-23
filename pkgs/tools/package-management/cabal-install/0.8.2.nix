{ cabal, Cabal, filepath, HTTP, network, random, time, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "0.8.2";
  sha256 = "8f896ab46ec6c578f620ce4150f7cd04a2088be793113b33cc570b13b6b86e0b";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath HTTP network random time zlib ];
  meta = {
    homepage = "http://www.haskell.org/cabal/";
    description = "The command-line interface for Cabal and Hackage";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
