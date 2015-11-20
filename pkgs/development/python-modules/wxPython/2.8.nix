{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2.8.12.1";
  sha256 = "1l1w4i113csv3bd5r8ybyj0qpxdq83lj6jrc5p7cc10mkwyiagqz";
})
