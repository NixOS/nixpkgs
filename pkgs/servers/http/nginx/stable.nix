{ callPackage, ... }@args:

callPackage ./generic.nix args {
  version = "1.30.6";
  hash = "sha256-PPRvXtdQTUYBJYZre+qZ+zV/MdiH4uY7NVAzEOm4tsg=";
  flavor = "stable";
}
