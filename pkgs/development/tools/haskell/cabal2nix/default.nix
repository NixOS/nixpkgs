{ cabal, Cabal, doctest, filepath, hackageDb, HTTP, mtl, regexPosix
}:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.47";
  sha256 = "1ba0ny610ibynwvzqnk5h2461sdkmza5jqrizqxvhp9wknn50fc6";
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
