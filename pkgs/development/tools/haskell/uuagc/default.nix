{ cabal, filepath, haskellSrcExts, mtl, uuagcCabal, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc";
  version = "0.9.50.2";
  sha256 = "1f587g4lf1gc5j9wd2fzxhjrny0a9axkpj6znxwsiylcpqw39dqs";
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
