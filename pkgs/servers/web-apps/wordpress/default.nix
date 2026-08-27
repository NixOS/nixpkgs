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
    version = "7.0.4";
    hash = "sha256-Jrmav8ZUJ/urUrJDFVOblE3O8UZ4maUla2wd4sSufkY=";
  };
}
