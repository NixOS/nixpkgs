{ cabal }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.1.0";
  name = self.fname;
  sha256 = "1b67869e493e56366207a128949998851f975d821e0952c2c717840d2eadaca7";
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
