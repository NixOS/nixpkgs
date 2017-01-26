{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.9";
  sha256 = "0j2pcara9ir2xj3m2mjzf7wz46mdy51c0kal61cp0ldm2qgvf8nw";
})
