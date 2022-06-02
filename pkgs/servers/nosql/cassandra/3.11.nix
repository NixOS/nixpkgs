{ callPackage, ... } @ args:
callPackage ./generic.nix (
  args
  // builtins.fromJSON (builtins.readFile ./3.11.json)
  // {
    generation = "3_11";
  })
