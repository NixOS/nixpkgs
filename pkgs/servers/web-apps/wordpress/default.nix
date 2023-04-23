{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_1;
  wordpress6_1 = {
    version = "6.1.1";
    hash = "sha256-IR6FSmm3Pd8cCHNQTH1oIaLYsEP1obVjr0bDJkD7H60=";
  };
}
