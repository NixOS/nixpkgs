{ cabal, hackageDb, HTTP, mtl, nixosTypes, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.15";
  sha256 = "0v2xnr8fp0bpv4cmd4q01p293zz4zg9kvhd4sr9ar3amj9vjhsk7";
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
