{ cabal, filepath, haskellSrcExts, mtl, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.42.1";
  sha256 = "1xyzvv9rqzqdc7kd2rncafnglfg699sn3f4987kbsxzhilvmhw78";
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
