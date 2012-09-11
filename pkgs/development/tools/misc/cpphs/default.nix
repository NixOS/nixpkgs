{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.14";
  sha256 = "1lscgylcbbny60lx36xwm8y22jmbv23159pfn8n87kbskq6cpk0z";
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
