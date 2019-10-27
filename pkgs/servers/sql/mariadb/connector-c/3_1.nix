{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.4";
  sha256 = "05jkaq151a45rqpyh0vrn6xcpawayfxyzhwn1w32hk0fw3z746ks";
})
