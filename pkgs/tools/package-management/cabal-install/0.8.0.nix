{ cabal, Cabal, filepath, HTTP, network, random, time, zlib }:

cabal.mkDerivation (self: {
  pname = "cabal-install";
  version = "0.8.0";
  sha256 = "6d16618ff454f8d732cad64a53b767b5b6bb95ba4970b260a40e8f467035493c";
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
