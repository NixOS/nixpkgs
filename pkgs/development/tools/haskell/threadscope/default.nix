{ cabal, binary, cairo, deepseq, filepath, ghcEvents, glib, gtk
, mtl, pango, time
}:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.2.1";
  sha256 = "08s9fbwg33rgbqjdx7n90q83livfay9khr2ddjwj8brw8k1wkmxg";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary cairo deepseq filepath ghcEvents glib gtk mtl pango time
  ];
  configureFlags = "--ghc-options=-rtsopts";
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/ThreadScope";
    description = "A graphical tool for profiling parallel Haskell programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
