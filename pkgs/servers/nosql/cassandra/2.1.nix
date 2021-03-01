{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.1.22";
  sha256 = "1wk57dz0kmc6d5y8d8dkx269lzh3ark3751z734gxncwdlclcyz3";
  generation = "2_1";
})
