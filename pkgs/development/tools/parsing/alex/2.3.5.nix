{ cabal, perl }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "2.3.5";
  sha256 = "0lyjiq4lmii2syk6838ln32qvn8c0ljf1ypsggahy748k05x79if";
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
