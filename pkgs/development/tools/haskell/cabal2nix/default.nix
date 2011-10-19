{ cabal, hackageDb, HTTP, mtl, nixosTypes, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.18";
  sha256 = "1bx9gv5nxz68p8rimai6gy05l84f7n3rajacvg6dak9nsrnbl95i";
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
