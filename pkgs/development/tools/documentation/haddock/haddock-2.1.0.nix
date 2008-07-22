{cabal}:

cabal.mkDerivation (self : {
  pname = "haddock";
  version = "2.1.0";
  name = self.fname;
  sha256 = "1b67869e493e56366207a128949998851f975d821e0952c2c717840d2eadaca7";
  meta = {
    description = "a tool for automatically generating documentation from annotated Haskell source code";
  };
})
