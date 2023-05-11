{ callPackage, ultimate, ... }:

let
  builder = if ultimate then ./ultimate-edition.nix
                        else ./community-edition.nix;
in callPackage builder {}
