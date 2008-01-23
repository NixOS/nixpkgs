{cabal, perl}:

cabal.mkDerivation (self : {

  # requires cabal-1.2 (and therefore, in Nix, currently ghc-6.8)

  pname = "happy";
  version = "1.17";
  name = self.fname;
  sha256 = "dca4e47d17e5d538335496236b3d2c3cbff644cf7380c987a4714e7784c70a2b";
  extraBuildInputs = [perl];
})
