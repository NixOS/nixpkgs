{ cabal, mtl, network, time }:

cabal.mkDerivation (self: {
  pname = "hslogger";
  version = "1.1.5";
  sha256 = "0lk966csxxyjjdg5jg4pzzl5118zj8ms78vn1n9imb7f4vcs8vk7";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl network time ];
  meta = {
    homepage = "http://software.complete.org/hslogger";
    description = "Versatile logging framework";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
