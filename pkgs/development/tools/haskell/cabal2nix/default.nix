{ cabal, HTTP, mtl, nixosTypes, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.12";
  sha256 = "14bijci07hkm3ksbqpzbnmwiysy5s3ll89r2iqkr1rbmj7bqxdwy";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ HTTP mtl nixosTypes regexPosix ];
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
