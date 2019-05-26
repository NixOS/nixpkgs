{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.2.13";
  sha256 = "19jryhjkh5jsgp6jlz2v28vwm5dks8i7mshsv3s2fpnl6147paaq";
})
