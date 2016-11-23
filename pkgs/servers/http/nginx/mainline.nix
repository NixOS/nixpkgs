{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.6";
  sha256 = "1gc5phrzm2hbpvryaya6rlvasa00vjips4hv5q1rqbcfa6xsnlri";
})
