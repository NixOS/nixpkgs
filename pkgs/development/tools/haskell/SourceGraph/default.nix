{ cabal, Cabal, fgl, filepath, Graphalyze, graphviz, haskellSrcExts
, mtl, multiset, random
}:

cabal.mkDerivation (self: {
  pname = "SourceGraph";
  version = "0.7.0.3";
  sha256 = "04bx7przxha38n9vckcxz3mbcxcws5ifbc1xfm0rg6bn8rym78yb";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal fgl filepath Graphalyze graphviz haskellSrcExts mtl multiset
    random
  ];
  meta = {
    description = "Static code analysis using graph-theoretic techniques";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
