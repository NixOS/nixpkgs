{ callPackage, branch }:

{
  sm64ex = callPackage ./sm64ex.nix { };

  sm64ex-coop = callPackage ./coop.nix { };
}
.${branch}
