{cabal, haskellSrcExts, mtl, uniplate, hscolour, parallel}:

cabal.mkDerivation (self : {
  pname = "hlint";
  version = "1.7.3";
  name = self.fname;
  sha256 = "afd4aa623fedf5257464bf18f38376a951d130f3004664803763e67cc55d9e83";
  extraBuildInputs = [haskellSrcExts mtl uniplate hscolour parallel];
  meta = {
    description = "Source code suggestions";
  };
})
