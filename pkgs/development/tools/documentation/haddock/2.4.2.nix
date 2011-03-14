{cabal, ghcPaths, libedit}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "2.4.2"; # Haskell Platform 2009.0.0
  name = self.fname;
  sha256 = "dbf0a7d0103a3ce6a91b2a3b96148c1b9c13ea7f8bd74260c21fe98df7839547";
  # TODO: adding libedit here is a hack
  propagatedBuildInputs = [ghcPaths libedit];
  meta = {
    description = "a tool for automatically generating documentation from annotated Haskell source code";
  };
})
