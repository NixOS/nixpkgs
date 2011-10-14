{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.13.2";
  sha256 = "1q3pzfcgrl9nka1gdl84c4fqc1ql83idlbb8fghqsjp0ijzcxk3s";
  isLibrary = true;
  isExecutable = true;
  meta = {
    homepage = "http://haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
