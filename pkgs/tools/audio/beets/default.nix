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
    version = "unstable-2024-03-16";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "b09806e0df8f01b9155017d3693764ae7beedcd5";
      hash = "sha256-jE6nZLOEFufqclT6p1zK7dW+vt69q2ulaRsUldL7cSQ=";
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
