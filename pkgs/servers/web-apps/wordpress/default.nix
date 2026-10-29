{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.10";
    hash = "sha256-+eHqMxMl9bwM+eQTdiPDH2AWgb1rNhvkqqzE/N9ZKJ8=";
  };
  wordpress_6_8 = {
    version = "6.8.11";
    hash = "sha256-Bp5CyKey0hevB+uQrZqQVJ+8PWL799xdkVRA04c/kVk=";
  };
  wordpress_6_9 = {
    version = "6.9.10";
    hash = "sha256-ocDcEuInHGr6q/Mp1a96l2+NLIxZJ3MXiluq6vwtT0o=";
  };
  wordpress_7_0 = {
    version = "7.0.7";
    hash = "sha256-5PEraQhT5M9lqmdNAYU21cRqWGmDE8WZfKDF0sa4ug0=";
  };
  wordpress_7_1 = {
    version = "7.1.3";
    hash = "sha256-0qCay2oV47nEcdclV3U8Jm1vQaee0Zv+BMv+SeKDsqU=";
  };
}
