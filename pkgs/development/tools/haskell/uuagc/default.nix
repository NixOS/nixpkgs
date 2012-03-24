{ cabal, filepath, haskellSrcExts, mtl, uuagcBootstrap, uuagcCabal
, uulib
}:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.40.3";
  sha256 = "053p7cbis843zn0qg8imc77xnfj4kna8wwfanxbj8kcapcqvwihl";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
