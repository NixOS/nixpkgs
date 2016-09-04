{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.3";
  sha256 = "042689m88bjhf7gsly4kl4gjyqdabcnizshxvdlp14gkz507yrja";
})
