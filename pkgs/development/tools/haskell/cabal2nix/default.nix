{ cabal, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.9";
  sha256 = "0wfagx42l3jcjclwyw914srramh9jind1988xg7dkxblngqw153v";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ HTTP mtl regexPosix ];
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
