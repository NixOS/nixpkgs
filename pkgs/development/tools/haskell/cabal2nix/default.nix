{ cabal, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.11";
  sha256 = "1df6bxgdzd3jfxfs3qg8qw6pmsfbd5l32krx9xdfkiqvfxa6vpy9";
  isLibrary = true;
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
