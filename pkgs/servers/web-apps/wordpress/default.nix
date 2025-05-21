{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_6;
  wordpress_6_5 = {
    version = "6.5.5";
    hash = "sha256-bIRmTqmzIRo1KdhAcJa1GxhVcTEiEaLFPzlNFbzfLcQ=";
  };
  wordpress_6_6 = {
    version = "6.6.1";
    hash = "sha256-YW6BhlP48okxLrpsJwPgynSHpbdRqyMoXaq9IBd8TlU=";
  };
}
