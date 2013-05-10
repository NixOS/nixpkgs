{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.16";
  sha256 = "1fv91s3h2s76h1hadb3mmnkg0rrfakmbfsrw6q522kshvpk2wmmp";
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
