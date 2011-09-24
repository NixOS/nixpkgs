{ cabal, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-cabal";
  version = "1.0.0.7";
  sha256 = "1ciypx0rrisjbwx8fc9bzkkv975646951ibqpvbxipxzvv5npy9y";
  buildDepends = [ mtl uulib ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Cabal plugin for the Universiteit Utrecht Attribute Grammar System";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
