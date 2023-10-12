{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_3;
  wordpress6_3 = {
    version = "6.3.1";
    hash = "sha256-HVV7pANMimJN4P1PsuAyIAZFejvYMQESXmVpoxac8X8=";
  };
}
