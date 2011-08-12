{ cabal, haskellSrcExts, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-bootstrap";
  version = "0.9.39.0.0";
  sha256 = "1ds98nif6naafgf6vgf19nmwx5gbhz88gsh2zyxc4d4iqb0z5drv";
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
