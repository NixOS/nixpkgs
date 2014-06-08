{ cabal, binary, cairo, deepseq, filepath, ghcEvents, glib, gtk
, mtl, pango, time
}:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.2.3";
  sha256 = "07kbkcckxfsb50zks8jgw2g0ary63hymicq5lqrm5jjaarjb80gr";
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
