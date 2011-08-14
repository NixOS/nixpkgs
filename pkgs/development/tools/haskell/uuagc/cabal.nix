{ cabal, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-cabal";
  version = "1.0.0.5";
  sha256 = "1is7kcbx7hlrzqxqz40sggniwxwnzd6k18dxsra4bibfcg8fvy4h";
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
