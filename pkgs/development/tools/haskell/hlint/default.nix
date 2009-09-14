{cabal, haskellSrcExts, mtl, uniplate, hscolour, parallel}:

cabal.mkDerivation (self : {
  pname = "hlint";
  version = "1.6.11";
  name = self.fname;
  sha256 = "20210c72826be92ae34247d4e02e64187c3c99f70f8a099c747c46415e010af5";
  extraBuildInputs = [haskellSrcExts mtl uniplate hscolour parallel];
  meta = {
    description = "Source code suggestions";
  };
})
