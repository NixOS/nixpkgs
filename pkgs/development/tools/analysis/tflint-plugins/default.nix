{ callPackage, ... }:
{
  tflint-ruleset-aws = callPackage ./tflint-ruleset-aws.nix { };
  tflint-ruleset-google = callPackage ./tflint-ruleset-google.nix { };
}
