{ cabal, polyparse, oldTime }:

cabal.mkDerivation (self: {
  pname = "cpphs";
  version = "1.18.6";
  sha256 = "0ds712zabigswf3cljzh7f2ys4rl1fj2cf76lbw856adm8514gxc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ oldTime polyparse ];
  meta = {
    homepage = "http://projects.haskell.org/cpphs/";
    description = "A liberalised re-implementation of cpp, the C pre-processor";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
