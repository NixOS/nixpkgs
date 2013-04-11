{ cabal, filepath, haskellSrcExts, mtl, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.42.3";
  sha256 = "0rn0wqccg2v4akh3wj16s5y60fscdfjpvrpsmvbc2vfq2v33y53n";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath haskellSrcExts mtl uuagcCabal uulib ];
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
