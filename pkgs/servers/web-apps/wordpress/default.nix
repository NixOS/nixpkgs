{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_6;
  wordpress_6_6 = {
    version = "6.6.2";
    hash = "sha256-JpemjLPc9IP0/OiASSVpjHRmQBs2n8Mt4nB6WcTCB9Y=";
  };
}
