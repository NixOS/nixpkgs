{ cabal }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "0.9";
  name = self.fname;
  sha256 = "beefd4a6da577978e7a79cabba60970accc5cd48fbb04c424a6b36ace3a9f8d0";
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "Haddock is a documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
