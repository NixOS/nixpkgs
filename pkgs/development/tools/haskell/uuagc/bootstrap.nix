{ cabal, haskellSrcExts, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-bootstrap";
  version = "0.9.39.3.0";
  sha256 = "0y1ipxkh9rl4mvw9a83dx0slr0ry1yw670z3w3dlb716xyzqyg5z";
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
