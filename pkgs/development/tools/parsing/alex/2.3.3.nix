{ cabal, perl }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "2.3.3";
  sha256 = "338fc492a1fddd6c528d0eb89857cadab211cb42680aeee1f9702bbfa7c5e1c8";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ perl ];
  doCheck = false;
  patches = [ ./adapt-crazy-perl-regex-for-cpp-4.8.0.patch ];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    hydraPlatforms = self.stdenv.lib.platforms.none;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
