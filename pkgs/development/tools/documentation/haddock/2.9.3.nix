{ cabal, alex, ghcPaths, happy, xhtml }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.9.3";
  sha256 = "0r3yp5s7qv9hmwwfz8rxbwj39qpysgyg53ka4alaxnfma0a96iyj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ ghcPaths xhtml ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
