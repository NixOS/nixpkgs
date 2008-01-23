{cabal}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "2.0.0.0";
  name = self.fname;
  sha256 = "a2ea5bdc127bc8b189a8d869f582ec774fea0933e7f5ca89549a6c142b9993df";
  meta = {
    description = "a tool for automatically generating documentation from annotated Haskell source code";
  };
})
