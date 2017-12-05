{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.4";
  sha256 = "1fpvy6738h951qks7wn6kdqwyprfsxirlxfq549n2p56kg2g68fy";
})
