{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_7;
  wordpress_6_7 = {
    version = "6.7";
    hash = "sha256-UDcayx3Leen0HHPcORZ+5cmvfod4BLOWB1HKd6j5rqM=";
  };
}
