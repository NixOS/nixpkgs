{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_0;
  wordpress6_0 = {
    version = "6.0.3";
    hash = "sha256-eSi0qwzXoJ1wYUzi34s7QbBbwRm2hfXoyGFivhPBq5o=";
  };
  wordpress6_1 = {
    version = "6.1.1";
    hash = "sha256-IR6FSmm3Pd8cCHNQTH1oIaLYsEP1obVjr0bDJkD7H60=";
  };
  wordpress6_2 = {
    version = "6.2";
    hash = "sha256-FDEo3rZc7SU9yqAplUScSMUWOEVS0e/PsrOPjS9m+QQ=";
  };
}
