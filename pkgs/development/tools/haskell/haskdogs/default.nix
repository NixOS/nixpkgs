{ cabal, Cabal, filepath, HSH }:

cabal.mkDerivation (self: {
  pname = "haskdogs";
  version = "0.3.1";
  sha256 = "08x7pi1xpdf0pq395mfff5g676ws59li8xx94xnvxxjcsid6i709";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal filepath HSH ];
  meta = {
    homepage = "http://github.com/ierton/haskdogs";
    description = "Generate ctags file for haskell project directory and it's deps";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
