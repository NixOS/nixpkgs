{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.4";
  sha256 = "11wr0vcps8w8g2sd8qwp1yp8y873c4q32azc041xpi7zqciqwnax";
})
