{ cabal }:

cabal.mkDerivation (self: {
  pname = "tar";
  version = "0.3.1.0";
  sha256 = "1n16sq5y7x30r1k7ydxmncn9x2nx3diildzyfxjy2b8drxp4jr03";
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
