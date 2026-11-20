{ callPackage, ... }@args:

callPackage ./generic.nix args {
  version = "1.31.9";
  hash = "sha256-oRxe7uLiV/RHjw5kn4SwBAeH0nfS0+UjOVKqa23LgK0=";
  flavor = "mainline";
}
