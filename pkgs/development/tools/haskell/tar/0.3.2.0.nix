{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "tar";
  version = "0.3.2.0";
  sha256 = "0yplrfai8bwihyn18whi0jiz1qzll9hgbc37xcy2jkr28480jba9";
  buildDepends = [ filepath ];
  meta = {
    description = "Reading, writing and manipulating \".tar\" archive files.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
