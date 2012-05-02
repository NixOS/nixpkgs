{ cabal, Cabal, filepath, hackageDb, HTTP, mtl, regexPosix }:

cabal.mkDerivation (self: {
  pname = "cabal2nix";
  version = "1.31";
  sha256 = "04qc74h6w3mvb3h3mv0hb3bbwk22ifl29hg3dcq1d5bg4y21j1vr";
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
