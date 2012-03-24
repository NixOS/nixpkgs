{ cabal, filepath, HUnit, mtl, random, regexPosix, time }:

cabal.mkDerivation (self: {
  pname = "MazesOfMonad";
  version = "1.0.7";
  sha256 = "1zk6bckll03b40iq8z13753glkmcan6439w8cc6rn5h2fhp189v9";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ filepath HUnit mtl random regexPosix time ];
  meta = {
    description = "Console-based Role Playing Game";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
