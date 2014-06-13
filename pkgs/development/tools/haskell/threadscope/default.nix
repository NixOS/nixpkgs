{ cabal, binary, cairo, deepseq, filepath, ghcEvents, glib, gtk
, mtl, pango, time
}:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.2.4";
  sha256 = "1208gp80vj3dngc4nrj1jk5y4h1181bgwq2qj764kcjvkaxch599";
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
