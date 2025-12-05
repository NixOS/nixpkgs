{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_8;
  wordpress_6_7 = {
    version = "6.7.3";
    hash = "sha256-zWLpZ/NKla1u4CHh2Bu0P7UmFWvnuTUheRq6Bq5NZjU=";
  };
  wordpress_6_8 = {
    version = "6.9";
    hash = "sha256-WzY5AjPjL+9oy19mQ1uzK91Q4LPfpXUKzrLePFmT1yA=";
  };
}
