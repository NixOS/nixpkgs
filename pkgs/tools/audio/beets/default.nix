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
      version = "2.5.0";
      src = fetchFromGitHub {
        owner = "beetbox";
        repo = "beets";
        tag = "v${version}";
        hash = "sha256-YZvS9oB+v+48i1avQcs6ClnYz4aMqJQ2e6cBiZ4ULb0=";
      };
    };

    beets-minimal = self.beets.override { disableAllPlugins = true; };

    alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
    audible = callPackage ./plugins/audible.nix { beets = self.beets-minimal; };
    copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
    filetote = callPackage ./plugins/filetote.nix { beets = self.beets-minimal; };
  }
  // lib.optionalAttrs config.allowAliases {
    beets-unstable = lib.warn "beets-unstable was aliased to beets, since upstream releases are frequent nowadays" self.beets;

    extrafiles = throw "extrafiles is unmaintained since 2020 and broken since beets 2.0.0";
  }
)
