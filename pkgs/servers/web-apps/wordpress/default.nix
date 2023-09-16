{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_3;
  wordpress6_3 = {
    version = "6.3.1";
    hash = "sha256-HVV7pANMimJN4P1PsuAyIAZFejvYMQESXmVpoxac8X8=";
  };
  wordpress6_2 = {
    version = "6.2.2";
    hash = "sha256-0qpvPauGbeP1MLHmz6gItJf80Erts7E7x28TM9AmAPk=";
  };
  wordpress6_1 = {
    version = "6.1.2";
    hash = "sha256-ozpuCVeni71CUylmUBk8wVo5ygZAKY7IdZ12DKbpSrw=";
  };
}
