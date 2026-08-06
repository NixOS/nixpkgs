{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_0;
  wordpress_6_8 = {
    version = "6.8.7";
    hash = "sha256-Fu0P83henBEdNbXXVb7cKc69zcLrGyRMx7LcTea+if0=";
  };
  wordpress_6_9 = {
    version = "6.9.5";
    hash = "sha256-01h7VJpvXZDG5PQmj/xsI2cUY2Jc+ImiyBWnB86fXEE=";
  };
  wordpress_7_0 = {
    version = "7.0.2";
    hash = "sha256-1KTSGd6mTGxo5i8v/D8zHFR1UQJG1sRPYftS83fSlbk=";
  };
}
