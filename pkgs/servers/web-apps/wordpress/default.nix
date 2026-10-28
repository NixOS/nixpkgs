{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_1;
  wordpress_6_9 = {
    version = "6.9.10";
    hash = "sha256-ocDcEuInHGr6q/Mp1a96l2+NLIxZJ3MXiluq6vwtT0o=";
  };
  wordpress_7_0 = {
    version = "7.0.7";
    hash = "sha256-5PEraQhT5M9lqmdNAYU21cRqWGmDE8WZfKDF0sa4ug0=";
  };
  wordpress_7_1 = {
    version = "7.1.4";
    hash = "sha256-iB5TpGgf8s2RFlGxHMze3lrkd93wdlr11qGoshmh2DU=";
  };
}
