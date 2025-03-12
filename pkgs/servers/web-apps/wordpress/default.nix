{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_7;
  wordpress_6_7 = {
    version = "6.7.2";
    hash = "sha256-z9nIPPqd2gNRiY6ptz9YmVyBeZSlQkvhh3f4PohqPPY=";
  };
}
