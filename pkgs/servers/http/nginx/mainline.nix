{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.10";
  sha256 = "0gak6pcsn1m8fsz0g95z4b72nn12ivy35vlxrmagfcvnn2mkr2vp";
})
