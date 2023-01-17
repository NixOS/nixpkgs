{ common
, patch-fix-aarch64-darwin-static
, ...
}:

common {
  version = "2.13.1";
  hash = "sha256-uXh4+xjJUHQSCg+LHh6+SSYtMdjKQiTXMZ4uZFwzdq4=";
  patches = [
    patch-fix-aarch64-darwin-static
  ];
}
