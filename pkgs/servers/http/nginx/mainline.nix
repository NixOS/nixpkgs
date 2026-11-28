{ callPackage, ... }@args:

callPackage ./generic.nix args {
  version = "1.31.10";
  hash = "sha256-qbaQlX/KhKva6Km1LWaxu0WSgtfwH+S5S0mO2Ol3vbM=";
  flavor = "mainline";
}
