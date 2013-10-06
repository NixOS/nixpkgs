{ cabal, Cabal, filepath, mtl, uulib }:

cabal.mkDerivation (self: {
  pname = "uuagc-cabal";
  version = "1.0.5.0";
  sha256 = "0p3rc1gszd62wwzzqz0hmj6jdmwdnpx92rdf6mgd7w63ic1wdxj5";
  buildDepends = [ Cabal filepath mtl uulib ];
  meta = {
    homepage = "http://www.cs.uu.nl/wiki/HUT/WebHome";
    description = "Cabal plugin for the Universiteit Utrecht Attribute Grammar System";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
