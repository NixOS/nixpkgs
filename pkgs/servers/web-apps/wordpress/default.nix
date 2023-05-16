{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_2;
  wordpress6_2 = {
<<<<<<< HEAD
    version = "6.2.2";
    hash = "sha256-0qpvPauGbeP1MLHmz6gItJf80Erts7E7x28TM9AmAPk=";
  };
  wordpress6_1 = {
    version = "6.1.2";
    hash = "sha256-ozpuCVeni71CUylmUBk8wVo5ygZAKY7IdZ12DKbpSrw=";
=======
    version = "6.2";
    hash = "sha256-FDEo3rZc7SU9yqAplUScSMUWOEVS0e/PsrOPjS9m+QQ=";
  };
  wordpress6_1 = {
    version = "6.1.1";
    hash = "sha256-IR6FSmm3Pd8cCHNQTH1oIaLYsEP1obVjr0bDJkD7H60=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
