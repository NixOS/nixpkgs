{ cabal, filepath, haskellSrcExts, mtl, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.50";
  sha256 = "0vyydqgmyl590ry63ibwshfpj2w9dd2v0nmr4jqlfw0m0d9ff50j";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath haskellSrcExts mtl uuagcCabal uulib ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Attribute Grammar System of Universiteit Utrecht";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
