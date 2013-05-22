{ cabal, Cabal, cmdargs, filepath, haskellSrcExts }:

cabal.mkDerivation (self: {
  pname = "packunused";
  version = "0.1.0.0";
  sha256 = "131x99id3jcxglj24p5sjb6mnhphj925pp4jdjy09y6ai7wss3rs";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal cmdargs filepath haskellSrcExts ];
  meta = {
    homepage = "https://github.com/hvr/packunused";
    description = "Tool for detecting redundant Cabal package dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
