{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.5";
    hash = "sha256-IS9B6kwjWLYLybmWG2Ym5+JAgFExMqhcEQsJJF2puXg=";
  };
  wordpress_6_8 = {
    version = "6.8.8";
    hash = "sha256-U4jnqPpGLDLkHOXKu3luIijNGHtrgNFdBpqNXm7NPgU=";
  };
  wordpress_6_9 = {
    version = "6.9.7";
    hash = "sha256-Ef1l7Mv03V3l7LNyS1X5LFbWweqWdJf+k3S83XpvvaY=";
  };
  wordpress_7_0 = {
    version = "7.0.5";
    hash = "sha256-DnEkM7Bi78lg0gVlu5seFEKdCq2eUUYUvHLA3Yg717k=";
  };
  wordpress_7_1 = {
    version = "7.1.1";
    hash = "sha256-OZb+4TRI7xLgfp8Md9svZV/6G3zeccgKSWXTvx+5VrM=";
  };
}
