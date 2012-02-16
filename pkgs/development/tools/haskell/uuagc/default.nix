{ cabal, filepath, haskellSrcExts, mtl, uuagcBootstrap, uuagcCabal
, uulib
}:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.40.2";
  sha256 = "1qc5sqm2lqysm5rplzc229rfw5750w4z8b7cgxaid7jjv4csrbf8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    filepath haskellSrcExts mtl uuagcBootstrap uuagcCabal uulib
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
