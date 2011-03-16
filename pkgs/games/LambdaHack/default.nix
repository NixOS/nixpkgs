{cabal, binary, mtl, zlib, vty, ConfigFile, MissingH, filepath}:

cabal.mkDerivation (self : {
  pname = "LambdaHack";
  version = "0.1.20110117";
  name = self.fname;
  sha256 = "186ccl1yq0r84h9azzwj0zyy3kf905i3kjlnziyi52ysqd61qw90";
  propagatedBuildInputs =
    [binary mtl zlib vty ConfigFile MissingH filepath];
  preConfigure = ''
    sed -i 's|\(filepath.*\) && < 1.2|\1|' ${self.pname}.cabal
  '';
  meta = {
    description = "a small roguelike game";
  };
})  

