{ cabal, haskellSrcExts, mtl, uuagcBootstrap, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.39.1";
  sha256 = "0zqhwpafq51czy97z0f93cbxd8k6hllnmb24a6yzr4y6kzzv65hd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    haskellSrcExts mtl uuagcBootstrap uuagcCabal uulib
  ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Attribute Grammar System of Universiteit Utrecht";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
