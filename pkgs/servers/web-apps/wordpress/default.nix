{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_0;
  wordpress_6_8 = {
    version = "6.8.8";
    hash = "sha256-U4jnqPpGLDLkHOXKu3luIijNGHtrgNFdBpqNXm7NPgU=";
  };
  wordpress_6_9 = {
    version = "6.9.7";
    hash = "sha256-Ef1l7Mv03V3l7LNyS1X5LFbWweqWdJf+k3S83XpvvaY=";
  };
  wordpress_7_0 = {
    version = "7.0.3";
    hash = "sha256-OOTH15WW1Y9g+lSWojVHFAfETcN6b5xNMdRgcJhei8Q=";
  };
}
