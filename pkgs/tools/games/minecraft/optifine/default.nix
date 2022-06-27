{ recurseIntoAttrs
, callPackage
, lib
}:

recurseIntoAttrs (
  builtins.mapAttrs
    (name: value: callPackage ./generic.nix value)
    (lib.importJSON ./versions.json)
)
