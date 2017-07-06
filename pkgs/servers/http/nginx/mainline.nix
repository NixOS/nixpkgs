{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.13.2";
  sha256 = "0w4vj6hl23z9kdw09v7jzq3c1593i4fhwmrz6qx2g7cq2i6j6zyp";
})
