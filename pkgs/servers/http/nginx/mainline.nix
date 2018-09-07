{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.3";
  sha256 = "11dysslkz76cdzhshc6w5qivdplk10pjpb73li0d1sz2qf8zp4ck";
})
