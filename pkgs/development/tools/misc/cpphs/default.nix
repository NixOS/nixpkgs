{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.17.1";
  sha256 = "1xk1gk3skgiy6bc8rdhm7i3f6b5nqsm9nz6qswbxq94nxmw3pg9p";
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
