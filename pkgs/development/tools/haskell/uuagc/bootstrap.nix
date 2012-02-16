{ cabal, filepath, haskellSrcExts, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-bootstrap";
  version = "0.9.40.2";
  sha256 = "0zsb8pz2zx7y8sjp392hpdk30dzzmppjizcnlgd1wvq2csacnfxq";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ filepath haskellSrcExts mtl uulib ];
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
