{ cabal, Cabal, doctest, filepath, hackageDb, HTTP, mtl, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.52";
  sha256 = "1w38qxwbwaq37c7vypydwjjhgrn9vbaqnnk7b2y0pm8n2fh78z1s";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath hackageDb HTTP mtl regexPosix ];
  testDepends = [ doctest ];
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
