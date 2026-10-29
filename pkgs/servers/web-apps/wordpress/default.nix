{ callPackage }:
builtins.mapAttrs (_: callPackage ./generic.nix) rec {
  wordpress = wordpress_6_9;
  wordpress_6_7 = {
    version = "6.7.11";
    hash = "sha256-r42LPAPO28vl3UFc8xb7JFX6rcJpL/gopU2CjxyESL4=";
  };
  wordpress_6_8 = {
    version = "6.8.12";
    hash = "sha256-S91r7zisRvgKzA079obZZwi1pE2ra7ZqDJfTw9dANx4=";
  };
  wordpress_6_9 = {
    version = "6.9.11";
    hash = "sha256-uHDQc9FdRXM3O87pYbnuzsixBjqr8mM1vZZImLDXcQo=";
  };
  wordpress_7_0 = {
    version = "7.0.8";
    hash = "sha256-TTrtbRfddyq6iiciJuYRYnzmW1MMgI21tmvSlaVN2yk=";
  };
  wordpress_7_1 = {
    version = "7.1.4";
    hash = "sha256-iB5TpGgf8s2RFlGxHMze3lrkd93wdlr11qGoshmh2DU=";
  };
}
