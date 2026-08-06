{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.5";
    hash = "sha256-IS9B6kwjWLYLybmWG2Ym5+JAgFExMqhcEQsJJF2puXg=";
  };
  wordpress_6_8 = {
    version = "6.8.7";
    hash = "sha256-Fu0P83henBEdNbXXVb7cKc69zcLrGyRMx7LcTea+if0=";
  };
  wordpress_6_9 = {
    version = "6.9.6";
    hash = "sha256-kyTKCV/z5RtKmrEcAdb8lPtutloBCjOHCSFTNwFCGH8=";
  };
  wordpress_7_0 = {
    version = "7.0.2";
    hash = "sha256-1KTSGd6mTGxo5i8v/D8zHFR1UQJG1sRPYftS83fSlbk=";
  };
}
