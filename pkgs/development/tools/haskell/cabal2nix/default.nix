{ cabal, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.10";
  sha256 = "1zyglwiv5xb5h21gcb0chcawlncnagivd2rziay4wv30xb06l804";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ HTTP mtl regexPosix ];
  meta = {
    homepage = "http://github.com/haskell4nix/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
