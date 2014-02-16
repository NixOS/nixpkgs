{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18";
  sha256 = "0b5hpqbzvw5dzkbjxqyc2d7ll2c6zf9wd8k182zhvz3kyxmkvs2s";
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
