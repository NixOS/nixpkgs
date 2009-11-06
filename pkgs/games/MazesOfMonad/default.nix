{cabal, HUnit, mtl, regexPosix, time}:

cabal.mkDerivation (self : {
  pname = "MazesOfMonad";
  version = "1.0.5";
  name = self.fname;
  sha256 = "a068df09975e7a3060cbd69191cbf99cb3a7b0ee524deb61eef4c52e7fada3f3";
  propagatedBuildInputs = [HUnit mtl regexPosix time];
  meta = {
    description = "Console-based Role Playing Game";
  };
})  

