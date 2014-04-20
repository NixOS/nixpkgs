{ cabal, mtl, fetchurl, alex, happy }:

cabal.mkDerivation (self: {
  pname = "BNFC";
  version = "2.6.0.3";
  sha256 = "0i38rwslkvnicnlxbrxybnwkgfin04lnr4q12lcvli4ldp2ylfjq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl ];
  buildTools = [ alex happy ];
  patches = [ (fetchurl { url = "https://github.com/BNFC/bnfc/pull/3.patch"; sha256 = "103l04ylzswgxrmpv5zy6dd0jyr96z21mdkpgk1z4prvn8wjl624"; }) ];
  patchFlags = "-p2";
  preConfigure = "runhaskell Setup.lhs clean";
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
