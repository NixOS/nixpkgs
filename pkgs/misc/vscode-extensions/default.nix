{ pkgs
, overrides ? self: super: { }
}:

# add extention to ./extentions file
# and then run 
#   $ cat extentions | ./update_installed_exts.sh > generated.nix

let
  inherit (pkgs.lib) fix fold extends;
  generated = import ./generated.nix { inherit pkgs; };
  overrides' = import ./overrides.nix { inherit pkgs; };
in (fix (extends overrides (extends overrides' generated)))

