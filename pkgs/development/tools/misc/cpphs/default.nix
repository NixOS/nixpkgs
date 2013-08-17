{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.17";
  sha256 = "01m71zhm16kdkagr2ykxr07vdvr4kvs8s8ar1dnlbdidb4szljzx";
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
