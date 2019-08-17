{ callPackage, ... } @ args:

callPackage ./. (args // {
  version = "2.3.7";
  sha256 = "13izi35vvxhiwl2dsnqrz75ciisy2s2k30giv7hrm01qlwnmiycl";
})
