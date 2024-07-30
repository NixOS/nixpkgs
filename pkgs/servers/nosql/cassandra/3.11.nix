{ callPackage, lib, ... } @ args:
callPackage ./generic.nix (
  args
  // lib.importJSON ./3.11.json
  // {
    generation = "3_11";
  })
