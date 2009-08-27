{cabal, mtl, pcreLight, readline}:

cabal.mkDerivation (self : {
  pname = "mkcabal";
  version = "0.4.2";
  name = self.fname;
  sha256 = "a3d781fdcdea4ac27a897888593091d4afee10dfc3eff5a49f9108b346232f50";
  propagatedBuildInputs = [mtl pcreLight readline];
  meta = {
    description = "Generate cabal files for a Haskell project";
  };
})
