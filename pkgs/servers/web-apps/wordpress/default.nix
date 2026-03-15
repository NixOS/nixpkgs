{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.3";
    hash = "sha256-zWLpZ/NKla1u4CHh2Bu0P7UmFWvnuTUheRq6Bq5NZjU=";
  };
  wordpress_6_8 = {
    version = "6.8.3";
    hash = "sha256-kto0yZYOZNElhlLB73PFF/fkasbf0t/HVDbThVr0aww=";
  };
  wordpress_6_9 = {
    version = "6.9.4";
    hash = "sha256-22EK2fVJ4Ku1rz49XGcpxY2HRDllTN8K/qQlsuqJXzU=";
  };
}
