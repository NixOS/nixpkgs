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
      version = "2.3.0";
      src = fetchFromGitHub {
        owner = "beetbox";
        repo = "beets";
        tag = "v${version}";
        hash = "sha256-mH3m2O+q5Ys9DJD3ulmhViyf/VPEpHevjmNerVe327s=";
      };
    };

    beets-minimal = self.beets.override { disableAllPlugins = true; };

    beets-unstable = callPackage ./common.nix {
      inherit python3Packages;
      version = "2.2.0-unstable-2025-03-12";
      src = fetchFromGitHub {
        owner = "beetbox";
        repo = "beets";
        rev = "670a3bcd17a46883c71cf07dd313fcd0dff4be9d";
        hash = "sha256-hSY7FhpPL4poOY1/gqk7oLNgQ7KA/MJqx50xOLIP0QA=";
      };
    };

    alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
    audible = callPackage ./plugins/audible.nix { beets = self.beets-minimal; };
    copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
  }
  // lib.optionalAttrs config.allowAliases {
    extrafiles = throw "extrafiles is unmaintained since 2020 and broken since beets 2.0.0";
  }
)
