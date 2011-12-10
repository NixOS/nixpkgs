{ cabal, hackageDb, HTTP, mtl, nixosTypes, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.21";
  sha256 = "00gsayb7axxm8z9jrngckb7c666x1kibvln67g2rpchi6djg6wn7";
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
