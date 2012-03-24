{ cabal, filepath }:

cabal.mkDerivation (self: {
  pname = "tar";
  version = "0.4.0.0";
  sha256 = "04qijdfyiqb64q58g0bf46qfgaxqjl3kl68x6z31cv36p3hpplx3";
  buildDepends = [ filepath ];
  meta = {
    description = "Reading, writing and manipulating \".tar\" archive files.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
