{ cabal, Cabal, filepath, hackageDb, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.29";
  sha256 = "1gqrl8085i7g64q085knjawqb3ynk13swrmry077ygw42hpvp2wg";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath hackageDb HTTP mtl regexPosix ];
  meta = {
    homepage = "http://github.com/NixOS/cabal2nix";
    description = "Convert Cabal files into Nix build instructions";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
