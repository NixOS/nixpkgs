{ cabal, Cabal, fgl, filepath, Graphalyze, graphviz, haskellSrcExts
, mtl, multiset, random
}:

cabal.mkDerivation (self: {
  pname = "SourceGraph";
  version = "0.7.0.5";
  sha256 = "0lbgs5a0ivn44bmc242hynsvczvxq2snz1fyjf13mrpfx8j5n8gk";
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
