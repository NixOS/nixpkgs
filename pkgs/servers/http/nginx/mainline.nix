{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.15.6";
  sha256 = "1ikchbnq1dv8wjnsf6jj24xkb36vcgigyps71my8r01m41ycdn53";
})
