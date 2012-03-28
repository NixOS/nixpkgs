{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.13.3";
  sha256 = "1dnz4992hr662ys1lkf6iyqmi2a3bksim8dlryqwd9wx9h24lhq2";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
