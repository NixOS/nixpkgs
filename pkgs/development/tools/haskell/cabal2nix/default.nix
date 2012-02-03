{ cabal, hackageDb, HTTP, mtl, nixosTypes, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.25";
  sha256 = "12csiw7j51vlf8l0prhjj06l7sqii12qy5ryl5n8vrgp8vch2kvl";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ hackageDb HTTP mtl nixosTypes regexPosix ];
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
