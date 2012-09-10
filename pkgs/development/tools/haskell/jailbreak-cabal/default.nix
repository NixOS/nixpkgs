{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "jailbreak-cabal";
  version = "1.0";
  sha256 = "10vq592fx1i3fdqiij7daf3dmqq5c8c29ihr2y1rn2pjhkyiy4kk";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://github.com/peti/jailbreak-cabal";
    description = "Strip version restrictions from build dependencies in Cabal files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
