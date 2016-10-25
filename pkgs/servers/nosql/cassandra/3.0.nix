{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.0.9";
  sha256 = "16jdh20cr4h47ldjqlnp2cdnb9zshqvnll6995s2a75d8m030c0g";
})
