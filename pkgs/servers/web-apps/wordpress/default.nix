{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.9";
    hash = "sha256-bvpXbX2A27vMqv6ES7qg5VZVRdWybipncJRURTHsc/0=";
  };
  wordpress_6_8 = {
    version = "6.8.10";
    hash = "sha256-B6Rh8L0foiV4cSUFS71KkMjEgXO9XT3chrZUeyuK+bQ=";
  };
  wordpress_6_9 = {
    version = "6.9.9";
    hash = "sha256-MiMbmsvnY6hhOOi7t7XE8/EjvsnWX8OJi8s7ZFBqc1g=";
  };
  wordpress_7_0 = {
    version = "7.0.6";
    hash = "sha256-W+/iSslL8f8YKSoaHzD9DHEbAJ+Rz9ytqo/rbgr6dc0=";
  };
  wordpress_7_1 = {
    version = "7.1.1";
    hash = "sha256-OZb+4TRI7xLgfp8Md9svZV/6G3zeccgKSWXTvx+5VrM=";
  };
}
