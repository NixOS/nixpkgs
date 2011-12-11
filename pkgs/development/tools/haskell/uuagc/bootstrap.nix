{ cabal, haskellSrcExts, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-bootstrap";
  version = "0.9.39.1.0";
  sha256 = "06w330j0nds5piv1rr3m6m1idnf0c5swfk9qwdqzi0pmpws6lpkj";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ haskellSrcExts mtl uulib ];
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
