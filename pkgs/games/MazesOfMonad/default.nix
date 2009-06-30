{cabal, HUnit, mtl, regexPosix, time}:

cabal.mkDerivation (self : {
  pname = "MazesOfMonad";
  version = "1.0.2";
  name = self.fname;
  sha256 = "cb5833d509a96fe7411b5eba981bd939da2942b47595d99b861028b9328a4748";
  propagatedBuildInputs = [HUnit mtl regexPosix time];
  meta = {
    description = "Console-based Role Playing Game";
  };
})  

