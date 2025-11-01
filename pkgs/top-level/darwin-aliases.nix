lib: self: super: pkgs:

### Deprecated aliases - for backward compatibility

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

  # Old Darwin pattern stubs; converted to throws in 25.11.

  mkThrow =
    name:
    throw "darwin.${name} has been removed as it was a legacy compatibility stub; see <https://nixos.org/manual/nixpkgs/stable/#sec-darwin-legacy-frameworks> for migration instructions";

  apple_sdk_11_0 = mkThrow "apple_sdk_11_0";

  apple_sdk_12_3 = mkThrow "apple_sdk_12_3";

  apple_sdk = apple_sdk_11_0;

  stubs = {
    inherit apple_sdk apple_sdk_11_0 apple_sdk_12_3;
  }
  // lib.genAttrs [
    "CF"
    "CarbonHeaders"
    "CommonCrypto"
    "CoreSymbolication"
    "IOKit"
    "Libc"
    "Libinfo"
    "Libm"
    "Libnotify"
    "Librpcsvc"
    "Libsystem"
    "LibsystemCross"
    "Security"
    "architecture"
    "cf-private"
    "configd"
    "configdHeaders"
    "darwin-stubs"
    "dtrace"
    "eap8021x"
    "hfs"
    "hfsHeaders"
    "launchd"
    "libclosure"
    "libdispatch"
    "libmalloc"
    "libobjc"
    "libplatform"
    "libpthread"
    "mDNSResponder"
    "objc4"
    "ppp"
    "xnu"
  ] mkThrow;
in

stubs
// mapAliases {
  # keep-sorted start case=no numeric=yes block=yes

  bsdmake = pkgs.bmake; # Added 2024-10-03
  cctools = pkgs.cctools; # Added 2024-07-17
  cctools-apple = pkgs.cctools; # Added 2024-07-01
  cctools-llvm = pkgs.cctools; # Added 2024-07-01
  cctools-port = pkgs.cctools; # Added 2024-07-17
  discrete-scroll = pkgs.discrete-scroll; # Added 2024-11-27
  ditto = throw "'darwin.ditto' has been removed, because it was impure and unused"; # Added 2025-10-18
  libresolvHeaders = throw "darwin.libresolvHeaders has been removed; use `lib.getInclude darwin.libresolv`"; # Converted to throw 2025-07-29
  libutilHeaders = throw "darwin.libutilHeaders has been removed; use `lib.getInclude darwin.libutil`"; # Converted to throw 2025-07-29
  moltenvk = pkgs.moltenvk; # Added 2024-10-06
  opencflite = pkgs.opencflite; # Added 2024-05-02
  stdenvNoCF = throw "darwin.stdenvNoCF has been removed; use `stdenv` or `stdenvNoCC`"; # converted to throw 2025-07-29
  sudo = throw "'darwin.sudo' has been removed, because it was impure and unused"; # Added 2025-10-18
  # keep-sorted end
}
