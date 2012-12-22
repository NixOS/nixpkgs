{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.15";
  sha256 = "1p2lf9zqiyydpq1vrqf8sw7mij5kw4pyggm41qgxn0a6lp6ni346";
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
