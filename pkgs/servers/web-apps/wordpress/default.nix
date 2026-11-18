{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_7_1;
  wordpress_6_9 = {
    version = "6.9.11";
    hash = "sha256-uHDQc9FdRXM3O87pYbnuzsixBjqr8mM1vZZImLDXcQo=";
  };
  wordpress_7_0 = {
    version = "7.0.8";
    hash = "sha256-TTrtbRfddyq6iiciJuYRYnzmW1MMgI21tmvSlaVN2yk=";
  };
  wordpress_7_1 = {
    version = "7.1.5";
    hash = "sha256-BThX2YDq7ocCxhfGhZSL7Lm+JSO6DcvJjk27IwA2fHk=";
  };
}
