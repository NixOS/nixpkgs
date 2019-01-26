{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.3";
  sha256 = "1fp2sm8v7dpp7iym39c7dh1fmi25x462amgzizl93c21rdq0cbnq";
})
