lib: self: super: pkgs:

### Deprecated aliases - for backward compatibility

### Please maintain this list in ASCIIbetical ordering.
### Hint: the "sections" are delimited by ### <letter> ###

# These aliases should not be used within nixpkgs, but exist to improve
# backward compatibility in projects outside of nixpkgs. See the
# documentation for the `allowAliases` option for more background.

# A script to convert old aliases to throws and remove old
# throws can be found in './maintainers/scripts/remove-old-aliases.py'.

# Add 'preserve, reason: reason why' after the date if the alias should not be removed.
# Try to keep them to a minimum.
# valid examples of what to preserve:
#   distro aliases such as:
#     debian-package-name -> nixos-package-name

# pkgs is provided to allow packages to be moved out of the darwin attrset.

with self;

let
  # Removing recurseForDerivation prevents derivations of aliased attribute set
  # to appear while listing all the packages available.
  removeRecurseForDerivations =
    alias:
    if alias.recurseForDerivations or false then
      lib.removeAttrs alias [ "recurseForDerivations" ]
    else
      alias;

  # Disabling distribution prevents top-level aliases for non-recursed package
  # sets from building on Hydra.
  removeDistribute = alias: if lib.isDerivation alias then lib.dontDistribute alias else alias;

  # Make sure that we are not shadowing something from darwin-packages.nix.
  checkInPkgs =
    n: alias:
    if builtins.hasAttr n super then throw "Alias ${n} is still in darwin-packages.nix" else alias;

  mapAliases = lib.mapAttrs (
    n: alias: removeDistribute (removeRecurseForDerivations (checkInPkgs n alias))
  );
in

mapAliases ({
  ### B ###

  builder = throw "'darwin.builder' has been changed and renamed to 'darwin.linux-builder'. The default ssh port is now 31022. Please update your configuration or override the port back to 22. See https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder"; # added 2023-07-06

  ### C ###
  cctools = pkgs.cctools; # added 2024-07-17
  cctools-apple = pkgs.cctools; # added 2024-07-01
  cctools-llvm = pkgs.cctools; # added 2024-07-01
  cctools-port = pkgs.cctools; # added 2024-07-17

  ### I ###

  insert_dylib = throw "'darwin.insert_dylib' has been renamed to 'insert-dylib'"; # added 2024-04-04

  ### L ###

  libauto = throw "'darwin.libauto' has been removed, as it was broken and unmaintained"; # added 2024-05-10
  libiconv = pkgs.libiconv; # 2024-03-27

  ### O ###

  opencflite = pkgs.opencflite; # added 2024-05-02
})
