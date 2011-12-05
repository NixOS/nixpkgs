{ cabal, haskellSrcExts, mtl, uuagcBootstrap, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.39.3";
  sha256 = "15wm7r7p9bzhad9nshv0r11h7if581dvlkyagx2whldk40clnk48";
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
