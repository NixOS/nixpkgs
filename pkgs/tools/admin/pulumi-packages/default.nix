{ callPackage }:
let
  mkPulumiPackage = callPackage ./base.nix { };
  callPackage' = p: args: callPackage p (args // { inherit mkPulumiPackage; });
in
{
  pulumi-random = callPackage' ./pulumi-random.nix { };
}
