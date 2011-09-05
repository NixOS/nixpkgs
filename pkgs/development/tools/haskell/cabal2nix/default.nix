{ cabal, hackageDb, HTTP, mtl, nixosTypes, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.14";
  sha256 = "0sdim1yqxx2wplfz6skz78y5lmh6dknc1k7jszmjnq0n9yc0b4bf";
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
