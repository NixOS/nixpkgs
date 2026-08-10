{ callPackage }:
{
  apacheKafka_4_3 = callPackage ./4_3.nix { };
  apacheKafka_4_2 = callPackage ./4_2.nix { };
  apacheKafka_4_1 = callPackage ./4_1.nix { };
}
