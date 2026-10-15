{ lib, callPackage }:

lib.recurseIntoAttrs {
  withStructuredAttrs = callPackage ./package.nix { __structuredAttrs = true; };
  withoutStructuredAttrs = callPackage ./package.nix { __structuredAttrs = false; };
}
