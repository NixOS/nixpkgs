{ cabal, Cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "BNFC";
  version = "2.4.2.0";
  sha256 = "0nnalzsql1k5y3s93g5y2hy2gcdsrbi8r7cwzmdcy4vyy589pin0";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal mtl ];
  meta = {
    homepage = "http://www.cse.chalmers.se/research/group/Language-technology/BNFC/";
    description = "A compiler front-end generator";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
