{cabal, haskellSrcExts, mtl, uniplate, hscolour, parallel, transformers}:

cabal.mkDerivation (self : {
  pname = "hlint";
  version = "1.8.7";
  name = self.fname;
  sha256 = "0k2fwwwmq0qqb5nw5acsjr2gqnsmqcf3ckb6wdrkqsqp8g2k14mn";
  extraBuildInputs =
    [haskellSrcExts mtl uniplate hscolour parallel transformers];
  meta = {
    description = "Source code suggestions";
  };
})
