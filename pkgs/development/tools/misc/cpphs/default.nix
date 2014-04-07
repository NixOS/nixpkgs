{ cabal, polyparse }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18.4";
  sha256 = "0rmcq66wn7lsc5g1wk6bbsr7jiw8h6bz5cbvdywnv7vmwsx8gh51";
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
