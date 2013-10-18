{ cabal, Cabal, cmdargs, filepath, haskellSrcExts }:

cabal.mkDerivation (self: {
  pname = "packunused";
  version = "0.1.0.1";
  sha256 = "130717k4rknj5jl904cmb4h09msp4xjj84w6iwzc10lz736dk3jd";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal cmdargs filepath haskellSrcExts ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/hvr/packunused";
    description = "Tool for detecting redundant Cabal package dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
