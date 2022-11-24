{ callPackage, ... }: {
  tflint-ruleset-aws = callPackage ./tflint-ruleset-aws.nix { };
}
