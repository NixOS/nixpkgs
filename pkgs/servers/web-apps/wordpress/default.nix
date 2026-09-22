{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_1;
  wordpress_6_9 = {
    version = "6.9.9";
    hash = "sha256-MiMbmsvnY6hhOOi7t7XE8/EjvsnWX8OJi8s7ZFBqc1g=";
  };
  wordpress_7_0 = {
    version = "7.0.6";
    hash = "sha256-W+/iSslL8f8YKSoaHzD9DHEbAJ+Rz9ytqo/rbgr6dc0=";
  };
  wordpress_7_1 = {
    version = "7.1.2";
    hash = "sha256-wMZmaJ1muHDYglUAu45ALtBN5SYCxhpvUWxiNrjJrGc=";
  };
}
