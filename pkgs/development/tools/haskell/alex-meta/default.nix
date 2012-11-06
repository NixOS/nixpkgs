{ cabal, haskellSrcMeta, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex-meta";
  version = "0.3.0.5";
  sha256 = "0f41q5l6z1dcpfx8rxacv4f544zcw7pgvq935mnzzha9fvsxqzk4";
  buildDepends = [ haskellSrcMeta QuickCheck ];
  meta = {
    description = "Quasi-quoter for Alex lexers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
