{ callPackage, fetchpatch }:

(callPackage ./generic.nix {
  gz-cmake = null;
})
  {
    version = "1.5.0";
    hash = "sha256-HgYT7MARRnOdUuUllxRn9pl7tsWO5RDIFDObzJQgZpc=";
  }
