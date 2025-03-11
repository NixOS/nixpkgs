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
  ### A ###

  apple_sdk_10_12 = throw "darwin.apple_sdk_10_12 was removed as Nixpkgs no longer supports macOS 10.12; see the 25.05 release notes"; # Added 2024-10-27

  ### B ###

  builder = throw "'darwin.builder' has been changed and renamed to 'darwin.linux-builder'. The default ssh port is now 31022. Please update your configuration or override the port back to 22. See https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder"; # added 2023-07-06
  bsdmake = pkgs.bmake; # added 2024-10-03

  ### C ###

  cctools = pkgs.cctools; # added 2024-07-17
  cctools-apple = pkgs.cctools; # added 2024-07-01
  cctools-llvm = pkgs.cctools; # added 2024-07-01
  cctools-port = pkgs.cctools; # added 2024-07-17

  cf-private = throw "'cf-private' has been renamed to 'apple_sdk.frameworks.CoreFoundation'.";

  ### D ###

  discrete-scroll = pkgs.discrete-scroll; # added 2024-11-27

  ### I ###

  insert_dylib = throw "'darwin.insert_dylib' has been renamed to 'insert-dylib'"; # added 2024-04-04
  ios-deploy = throw "'darwin.ios-deploy' has been renamed to 'ios-deploy'"; # added 2024-11-28
  iproute2mac = lib.warnOnInstantiate "darwin.iproute2mac has been renamed to iproute2mac" pkgs.iproute2mac; # added 2024-12-08

  ### L ###

  libauto = throw "'darwin.libauto' has been removed, as it was broken and unmaintained"; # added 2024-05-10
  libtapi = pkgs.libtapi; # 2024-08-16

  ### M ###

  moltenvk = pkgs.moltenvk; # 2024-10-06

  ### O ###

  opencflite = pkgs.opencflite; # added 2024-05-02
})
