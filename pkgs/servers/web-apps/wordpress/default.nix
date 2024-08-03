{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_6;
  wordpress6_3 = {
    version = "6.3.4";
    hash = "sha256-Z94B2PQ/wl2N1MPMH15CToI3taKDHFRnbAl/Nt9jB+I=";
  };
  wordpress6_4 = {
    version = "6.4.4";
    hash = "sha256-aLOO/XgjI3d/+1BpHDT2pGR697oceghjzOId1MjC+wQ=";
  };
  wordpress6_5 = {
    version = "6.5.5";
    hash = "sha256-bIRmTqmzIRo1KdhAcJa1GxhVcTEiEaLFPzlNFbzfLcQ=";
  };
  wordpress_6_6 = {
    version = "6.6.1";
    hash = "sha256-YW6BhlP48okxLrpsJwPgynSHpbdRqyMoXaq9IBd8TlU=";
  };
}
