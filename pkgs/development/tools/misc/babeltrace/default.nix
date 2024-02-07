{ callPackage }:

{
  v1 = callPackage ./v1.nix { };
  v2 = callPackage ./v2.nix { };
}
