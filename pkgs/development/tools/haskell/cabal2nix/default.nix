{ cabal, Cabal, filepath, hackageDb, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.34";
  sha256 = "0iz9a91hp6frrkshjhyi3sacqlb547bjs2mqlzfjxiyhkfb3mc40";
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
