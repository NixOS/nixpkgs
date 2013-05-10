{ cabal, binary, cairo, deepseq, filepath, ghcEvents, glib, gtk
, mtl, pango, time
}:

cabal.mkDerivation (self: {
  pname = "threadscope";
  version = "0.2.2";
  sha256 = "07cmza391hjq77lx8m9g2287bzsh5ffka3s07fr49v6x6hivsic3";
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
