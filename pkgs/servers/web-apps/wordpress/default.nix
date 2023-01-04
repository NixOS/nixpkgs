{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) {
  wordpress = {
    version = "6.0.3";
    hash = "sha256-eSi0qwzXoJ1wYUzi34s7QbBbwRm2hfXoyGFivhPBq5o=";
  };
  wordpress6_1 = {
    version = "6.1.1";
    hash = "sha256-IR6FSmm3Pd8cCHNQTH1oIaLYsEP1obVjr0bDJkD7H60=";
  };
}
