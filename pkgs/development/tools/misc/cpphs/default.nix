{ cabal, polyparse }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18.5";
  sha256 = "0bqfz0wkfnxvv711fgmhmh6rbwffgna1pfqbj7whb6crqji9w7g7";
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
