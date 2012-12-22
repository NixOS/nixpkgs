{ cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "BNFC";
  version = "2.4.2.1";
  sha256 = "0a6ic9mqkxk2gql7dzik2bhm5iikgx035wxlz8iafxf45159dl14";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ mtl ];
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
