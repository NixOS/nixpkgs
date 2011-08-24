{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.12";
  sha256 = "18c8yx8y54b2q086sqlp4vhslkb7mm1gry1f13mki43x93kd1vdj";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
