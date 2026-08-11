{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_0;
  wordpress_6_8 = {
    version = "6.8.7";
    hash = "sha256-Fu0P83henBEdNbXXVb7cKc69zcLrGyRMx7LcTea+if0=";
  };
  wordpress_6_9 = {
    version = "6.9.6";
    hash = "sha256-kyTKCV/z5RtKmrEcAdb8lPtutloBCjOHCSFTNwFCGH8=";
  };
  wordpress_7_0 = {
    version = "7.0.3";
    hash = "sha256-OOTH15WW1Y9g+lSWojVHFAfETcN6b5xNMdRgcJhei8Q=";
  };
}
