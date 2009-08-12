{cabal, haskellSrcExts, mtl, uniplate, hscolour, parallel}:

cabal.mkDerivation (self : {
  pname = "hlint";
  version = "1.6.5";
  name = self.fname;
  sha256 = "70b8a70e268e5cd5079e1d187cba83f20a2fd967668a0fdf92f5207ec96e1a7e";
  extraBuildInputs = [haskellSrcExts mtl uniplate hscolour parallel];
  meta = {
    description = "Source code suggestions";
  };
})
