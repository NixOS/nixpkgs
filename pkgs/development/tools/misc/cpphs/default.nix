{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.13.1";
  sha256 = "0k5p9gqnalll3w1962dwydnygk25h777bic2gvdh8i8hhyz5fsx2";
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
