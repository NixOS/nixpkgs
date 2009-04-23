{cabal, haskellSrcExts, mtl, uniplate, hscolour}:

cabal.mkDerivation (self : {
  pname = "hlint";
  version = "1.4";
  name = self.fname;
  sha256 = "deddcd8b2a2e1dce2510395dae1d6c78dc9264766e362ff378fe0f008db42e4e";
  extraBuildInputs = [haskellSrcExts mtl uniplate hscolour];
  meta = {
    description = "Source code suggestions";
  };
})
