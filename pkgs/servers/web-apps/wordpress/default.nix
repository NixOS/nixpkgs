{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.5";
    hash = "sha256-IS9B6kwjWLYLybmWG2Ym5+JAgFExMqhcEQsJJF2puXg=";
  };
  wordpress_6_8 = {
    version = "6.8.5";
    hash = "sha256-N/WVUQxI0W3t4L+lr6KcuK8S2/Dj00WyXElMFfjIHYE=";
  };
  wordpress_6_9 = {
    version = "6.9.1";
    hash = "sha256-hchDaZiHDkKjmudViwltGdKUoM0q23yH7nZNuXOwGVM=";
  };
}
