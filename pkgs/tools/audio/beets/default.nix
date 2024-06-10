{ lib
, callPackage
, fetchFromGitHub
, fetchPypi
, fetchpatch
, python3Packages
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
lib.makeExtensible (self: {
  beets = self.beets-stable;

  beets-stable = callPackage ./common.nix rec {
    inherit python3Packages;
    # NOTE: ./builtin-plugins.nix and ./common.nix can have some conditionals
    # be removed when stable version updates
    version = "2.0.0";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "v${version}";
      hash = "sha256-6pmImyopy0zFBDYoqDyWcBv61FK1kGsZwW2+7fzAnq8=";
    };
    extraPatches = [
      # Bash completion fix for Nix
      ./patches/bash-completion-always-print.patch
    ];
  };

  beets-minimal = self.beets.override { disableAllPlugins = true; };

  beets-unstable = callPackage ./common.nix {
    inherit python3Packages;
    version = "2.0.0-unstable-2024-05-25";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "2130404217684f22f36de00663428602b3f96d84";
      hash = "sha256-trqF6YVBcv+i5H4Ez3PKnRQ6mV2Ly/cw3UJC7pl19og=";
    };
    extraPatches = [
      # Bash completion fix for Nix
      ./patches/bash-completion-always-print.patch
    ];
  };

  alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
  copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
  extrafiles = callPackage ./plugins/extrafiles.nix { beets = self.beets-minimal; };
})
