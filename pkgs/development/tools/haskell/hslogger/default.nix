{ cabal, mtl, network, time }:

cabal.mkDerivation (self: {
  pname = "hslogger";
  version = "1.2.3";
  sha256 = "0rmijkrf24srcg8zgizf5vidpsgr4171wbzbwgrg66l704mkkb7m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network time ];
  meta = {
    homepage = "http://software.complete.org/hslogger";
    description = "Versatile logging framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
