{ cabal, Cabal, extensibleExceptions, fgl, filepath, Graphalyze
, graphviz, haskellSrcExts, mtl, multiset, random
}:

cabal.mkDerivation (self: {
  pname = "SourceGraph";
  version = "0.7.0.1";
  sha256 = "0f6h240a72cxa65cwjrp34cx80c6frzhgl9dpv3krc8xzhxssk78";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    Cabal extensibleExceptions fgl filepath Graphalyze graphviz
    haskellSrcExts mtl multiset random
  ];
  meta = {
    description = "Static code analysis using graph-theoretic techniques";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
