{ callPackage }: builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress6_5;
  wordpress6_3 = {
    version = "6.3.4";
    hash = "sha256-Z94B2PQ/wl2N1MPMH15CToI3taKDHFRnbAl/Nt9jB+I=";
  };
  wordpress6_4 = {
    version = "6.4.3";
    hash = "sha256-PwjHHRlwhEH9q94bPq34NnQv3uhm1kOpjRAu0/ECaYY=";
  };
  wordpress6_5 = {
    version = "6.5";
    hash = "sha256-NCRWKIrhSMC6itw2y/WJUd2LSRtnVWkmVO/b2nEJK58=";
  };
}
