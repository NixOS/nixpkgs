{ cabal, mtl, network, time }:

cabal.mkDerivation (self: {
  pname = "hslogger";
  version = "1.2.2";
  sha256 = "0j15nma6yf3cxb9j232kif1a836zmncfyklz9wp1mx064nblr5jf";
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
