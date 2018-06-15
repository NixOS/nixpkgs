{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.14.0";
  sha256 = "1d9c0avfpbwvzyg53b59ks8shpnrxnbnshcd7ziizflsyv5vw5ax";
})
