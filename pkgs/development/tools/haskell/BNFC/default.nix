{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "BNFC";
  version = "2.6.0.3";
  sha256 = "0i38rwslkvnicnlxbrxybnwkgfin04lnr4q12lcvli4ldp2ylfjq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  meta = {
    homepage = "http://bnfc.digitalgrammars.com/";
    description = "A compiler front-end generator";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
