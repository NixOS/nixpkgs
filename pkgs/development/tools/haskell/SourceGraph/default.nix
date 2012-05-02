{ cabal, Cabal, fgl, filepath, Graphalyze, graphviz, haskellSrcExts
, mtl, multiset, random
}:

cabal.mkDerivation (self: {
  pname = "SourceGraph";
  version = "0.7.0.2";
  sha256 = "0cdspzsz15r83fjry9467z67h6vvnjh31fip6gf64k74gdjkfisl";
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
