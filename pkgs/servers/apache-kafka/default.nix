{ callPackage }:
{
  apacheKafka_4_4 = callPackage ./4_4.nix { };
  apacheKafka_4_3 = callPackage ./4_3.nix { };
  apacheKafka_4_2 = callPackage ./4_2.nix { };
}
