{ lib, callPackage }:

lib.recurseIntoAttrs {
  nixos = callPackage ./nixos { };
}
