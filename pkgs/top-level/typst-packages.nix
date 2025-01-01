{ callPackage }:

{
  oxifmt = callPackage ../development/typst-packages/oxifmt.nix { };

  polylux = callPackage ../development/typst-packages/polylux.nix { };
}
