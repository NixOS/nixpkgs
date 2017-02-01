{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.10.3";
  sha256 = "146xd566l1wkhzxqhmd01vj7c0yhsap1qkiwfg5mki6ach9hy0km";
})
