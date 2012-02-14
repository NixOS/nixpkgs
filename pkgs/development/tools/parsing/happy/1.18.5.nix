{ cabal, Cabal, mtl, perl }:

cabal.mkDerivation (self: {
  pname = "happy";
  version = "1.18.5";
  sha256 = "91e1c29ac42bc5cabcac2c2e28e693fc59fbdf30636e5c52cb51b779a74d755e";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal mtl ];
  buildTools = [ perl ];
  meta = {
    homepage = "http://www.haskell.org/happy/";
    description = "Happy is a parser generator for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
