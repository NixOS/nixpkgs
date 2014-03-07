{ cabal, polyparse }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18.3";
  sha256 = "0m2083ynjfxad4ykvpm6c7q1clrm7nsvbwv10abhyzqkpazyzzxy";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ polyparse ];
  meta = {
    homepage = "http://projects.haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
