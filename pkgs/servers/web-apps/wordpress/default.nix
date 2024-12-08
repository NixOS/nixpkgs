{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_7;
  wordpress_6_7 = {
    version = "6.7.1";
    hash = "sha256-M1Kc1jjIRQB+jg0myR1gycFrgiyEnI3urQPQyFGibes=";
  };
}
