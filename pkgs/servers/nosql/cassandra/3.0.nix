{ callPackage, ... } @ args:
callPackage ./generic.nix (
  args
  // builtins.fromJSON (builtins.readFile ./3.0.json)
  // {
    generation = "3_0";
  })
