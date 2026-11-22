{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_1;
  wordpress_6_9 = {
    version = "6.9.12";
    hash = "sha256-mjwLBMsFGG9rLK2VW9aw1wnqIZhUdsis5CX/0zb8tRM=";
  };
  wordpress_7_0 = {
    version = "7.0.9";
    hash = "sha256-eGvy/Hst+g4sxdeDOx42C/7DBNVrroQWJrW7mGPlrIw=";
  };
  wordpress_7_1 = {
    version = "7.1.5";
    hash = "sha256-BThX2YDq7ocCxhfGhZSL7Lm+JSO6DcvJjk27IwA2fHk=";
  };
}
