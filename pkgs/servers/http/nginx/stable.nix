{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.12.1";
  sha256 = "1yvnmj7vlykrqdi6amkvs63lva6qkxd98sqv0a8hz8w5ci1bz4w7";
})
