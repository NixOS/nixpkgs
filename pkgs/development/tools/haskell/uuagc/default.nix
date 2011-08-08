{ cabal, haskellSrcExts, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.38.6";
  sha256 = "1dr8vxis16rcdvklp0rv2d50bi33jag7n4wynbfqw9bzgyfbagnw";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ haskellSrcExts mtl uulib ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Attribute Grammar System of Universiteit Utrecht";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
