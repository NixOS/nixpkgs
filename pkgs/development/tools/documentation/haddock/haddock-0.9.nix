{cabal}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "0.9";
  name = self.fname;
  sha256 = "beefd4a6da577978e7a79cabba60970accc5cd48fbb04c424a6b36ace3a9f8d0";
  meta = {
    description = "a tool for automatically generating documentation from annotated Haskell source code";
  };
})
