{ cabal, extensibleExceptions, mtl, pcreLight, readline }:

cabal.mkDerivation (self: {
  pname = "mkcabal";
  version = "1.0.0";
  sha256 = "1cmawm49i01xxvzgf67cin6s9hihfc3ihr6s5hn2makasfxbnryc";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ extensibleExceptions mtl pcreLight readline ];
  meta = {
    homepage = "http://code.haskell.org/~dons/code/mkcabal";
    description = "Generate cabal files for a Haskell project";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
