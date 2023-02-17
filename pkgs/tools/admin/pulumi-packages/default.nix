{ callPackage }:
let
  mkPulumiPackage = callPackage ./base.nix { };
  callPackage' = p: args: callPackage p (args // { inherit mkPulumiPackage; });
in
{
  pulumi-aws-native = callPackage' ./pulumi-aws-native.nix { };
  pulumi-azure-native = callPackage' ./pulumi-azure-native.nix { };
  pulumi-language-nodejs = callPackage ./pulumi-language-nodejs.nix { };
  pulumi-language-python = callPackage ./pulumi-language-python.nix { };
  pulumi-random = callPackage' ./pulumi-random.nix { };
}
