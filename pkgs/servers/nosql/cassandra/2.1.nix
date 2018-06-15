{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.1.19";
  sha256 = "1qlc62j3hf5831yrrbydn3z19zrn6bpirarinys6bmhshr7mhpyr";
})
