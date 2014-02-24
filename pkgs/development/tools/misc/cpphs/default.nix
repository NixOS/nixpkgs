{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18.1";
  sha256 = "1fshsd1dzmrl3qbpwf7r2c30d08l77080j9cfchcgy1lijjr9vhm";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://projects.haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
