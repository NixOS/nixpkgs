{ cabal, diagramsLib, diagramsSvg, filepath, ghcEvents, lens, mtl
, optparseApplicative, parsec, SVGFonts, thLift, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-events-analyze";
  version = "0.2.0";
  sha256 = "04px1p0pnx54414m7sdpmdhj2dpsi1z8bjm8jq2yzh66854xiyh4";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    diagramsLib diagramsSvg filepath ghcEvents lens mtl
    optparseApplicative parsec SVGFonts thLift transformers
  ];
  meta = {
    description = "Analyze and visualize event logs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
