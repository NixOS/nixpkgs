{ callPackage, ... }@args:

callPackage ./generic.nix args {
  version = "1.31.7";
  hash = "sha256-ieqKPcFxUR9zJQQ7UOTANiSNn61f637ICcC4LV30LGU=";
  flavor = "mainline";
}
