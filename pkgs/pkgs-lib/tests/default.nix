# Call nix-build on this file to run all tests in this directory

# This produces a link farm derivation with the original attrs
# merged on top of it.
# You can run parts of the "hierarchy" with for example:
#     nix-build -A java-properties
# See `structured` below.

{ pkgs ? import ../../.. { } }:
let
  inherit (pkgs.lib) mapAttrs mapAttrsToList isDerivation mergeAttrs foldl' attrValues recurseIntoAttrs;

  structured = {
    formats = import ./formats.nix { inherit pkgs; };
    java-properties = recurseIntoAttrs {
      jdk8 = pkgs.callPackage ../formats/java-properties/test { jdk = pkgs.jdk8; };
      jdk11 = pkgs.callPackage ../formats/java-properties/test { jdk = pkgs.jdk11_headless; };
      jdk17 = pkgs.callPackage ../formats/java-properties/test { jdk = pkgs.jdk17_headless; };
    };
  };

  flatten = prefix: as:
    foldl'
      mergeAttrs
      { }
      (attrValues
        (mapAttrs
          (k: v:
            if isDerivation v
            then { "${prefix}${k}" = v; }
            else if v?recurseForDerivations
            then flatten "${prefix}${k}-" (removeAttrs v [ "recurseForDerivations" ])
            else builtins.trace v throw "expected derivation or recurseIntoAttrs")
          as
        )
      );
in

# It has to be a link farm for inclusion in the hydra unstable jobset.
pkgs.linkFarm "pkgs-lib-formats-tests"
  (mapAttrsToList
    (k: v: { name = k; path = v; })
    (flatten "" structured)
  )
// structured
