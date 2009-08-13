{cabal, binary, mtl, zlib, vty}:

cabal.mkDerivation (self : {
  pname = "LambdaHack";
  version = "0.1.20090606";
  name = self.fname;
  sha256 = "9b8d790b0a99231aff2d108b50dd2f2998b09bec3ffedf9f1415557aaeb6039b";
  propagatedBuildInputs = [binary mtl zlib vty];
  meta = {
    description = "a small roguelike game";
  };
})  

