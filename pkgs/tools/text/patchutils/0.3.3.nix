{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // {
    version = "0.3.3";
    sha256 = "0g5df00cj4nczrmr4k791l7la0sq2wnf8rn981fsrz1f3d2yix4i";
    patches = [ ./drop-comments.patch ]; # we would get into a cycle when using fetchpatch on this one
  }
)
