{ callPackage }:

{
  cetz = callPackage ../development/typst-packages/cetz.nix { };

  oxifmt = callPackage ../development/typst-packages/oxifmt.nix { };

  polylux = callPackage ../development/typst-packages/polylux.nix { };
}
