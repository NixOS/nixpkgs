{ callPackage }:
let
  mkPulumiPackage = callPackage ./base.nix { };
  callPackage' = p: args: callPackage p (args // { inherit mkPulumiPackage; });
in
{
  pulumi-language-python = callPackage ./pulumi-language-python.nix { };
  pulumi-random = callPackage' ./pulumi-random.nix { };
}
