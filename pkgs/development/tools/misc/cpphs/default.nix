{ cabal }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.13";
  sha256 = "0igk4210vsskcx3zn97rx0q4prxd2ri3yl787dn4ladn0zm676iq";
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
