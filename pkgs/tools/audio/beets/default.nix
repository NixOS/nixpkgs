{
  lib,
  callPackage,
  config,
  fetchFromGitHub,
  python3Packages,
}:
/*
  ** To customize the enabled beets plugins, use the pluginOverrides input to the
  ** derivation.
  ** Examples:
  **
  ** Disabling a builtin plugin:
  ** beets.override { pluginOverrides = { beatport.enable = false; }; }
  **
  ** Enabling an external plugin:
  ** beets.override { pluginOverrides = {
  **   alternatives = { enable = true; propagatedBuildInputs = [ beetsPackages.alternatives ]; };
  ** }; }
*/
let
  extraPatches = [
    # Bash completion fix for Nix
    ./patches/bash-completion-always-print.patch
  ];
in
lib.makeExtensible (
  self:
  {
    beets = self.beets-stable;

    beets-stable = callPackage ./common.nix rec {
      inherit python3Packages extraPatches;
      version = "2.3.1";
      src = fetchFromGitHub {
        owner = "beetbox";
        repo = "beets";
        tag = "v${version}";
        hash = "sha256-INxL2XDn8kwRYYcZATv/NdLmAtfQvxVDWKB1OYo8dxY=";
      };
    };

    beets-minimal = self.beets.override { disableAllPlugins = true; };

    beets-unstable = callPackage ./common.nix {
      inherit python3Packages;
      version = "2.3.1";
      src = fetchFromGitHub {
        owner = "beetbox";
        repo = "beets";
        rev = "d487d675b9115672c484eab8a6729b1f0fd24b68";
        hash = "sha256-INxL2XDn8kwRYYcZATv/NdLmAtfQvxVDWKB1OYo8dxY=";
      };
    };

    alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
    audible = callPackage ./plugins/audible.nix { beets = self.beets-minimal; };
    copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
    filetote = callPackage ./plugins/filetote.nix { beets = self.beets-minimal; };
  }
  // lib.optionalAttrs config.allowAliases {
    extrafiles = throw "extrafiles is unmaintained since 2020 and broken since beets 2.0.0";
  }
)
