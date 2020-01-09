{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "3.1.5";
  sha256 = "1mfrm595kfnpjladaq6m184npa3rxff9pr1vwa35r057s7nmzpm9";
})
