{ callPackage }:
{
  apacheKafka_4_1 = callPackage ./4_1.nix { };
  apacheKafka_4_0 = callPackage ./4_0.nix { };
  apacheKafka_3_9 = callPackage ./3_9.nix { };
}
