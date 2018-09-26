{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in
  rec {
    sublimeMerge = common {
      buildVersion = "1058";
      x64sha256 = "1yj3cg3z9421h36mgjprr94p4m0i4hl4ndi215bfp1i1b02rrva8";
    } {};
    sublimeMerge-dev = common {
      buildVersion = "1060";
      x64sha256 = "e3b362d9e544157fa6e1811dc4e8892387a0609858a2503f45aeb62f19aefa2a";
    } {};
  }
