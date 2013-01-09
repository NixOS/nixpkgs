{ cabal, Cabal, fgl, filepath, Graphalyze, graphviz, haskellSrcExts
, mtl, multiset, random
}:

cabal.mkDerivation (self: {
  pname = "SourceGraph";
  version = "0.7.0.4";
  sha256 = "1rxbanvw1dpdnpmrf5gpl12gn9796yq89dnmdxy56mb9qzsm7nm6";
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
