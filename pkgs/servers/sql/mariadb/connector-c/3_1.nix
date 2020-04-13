{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.7";
  sha256 = "16pmdms454jbralaw6rpx0rjlf2297p6h3q8wfk0n87kbn7vrxv4";
})
