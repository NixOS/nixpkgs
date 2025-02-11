{
  lib,
  callPackage,
  fetchFromGitHub,
  python3Packages,
  fetchpatch,
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
    # Remove after next release.
    (fetchpatch {
      url = "https://github.com/beetbox/beets/commit/bcc79a5b09225050ce7c88f63dfa56f49f8782a8.patch?full_index=1";
      hash = "sha256-Y2Q5Co3UlDGKuzfxUvdUY3rSMNpsBoDW03ZWZOfzp3Y=";
    })
  ];
in
lib.makeExtensible (self: {
  beets = self.beets-stable;

  beets-stable = callPackage ./common.nix rec {
    inherit python3Packages extraPatches;
    version = "2.2.0";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "v${version}";
      hash = "sha256-jhwXRgUUQJgQ/PLwvY1UfHCJ9UC8DcdBpE/janao0RM=";
    };
  };

  beets-minimal = self.beets.override { disableAllPlugins = true; };

  beets-unstable = callPackage ./common.nix {
    inherit python3Packages extraPatches;
    version = "2.2.0-unstable-2024-12-02";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "f92c0ec8b14fbd59e58374fd123563123aef197b";
      hash = "sha256-jhwXRgUUQJgQ/PLwvY1UfHCJ9UC8DcdBpE/janao0RM=";
    };
  };

  alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
  copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };

  extrafiles = throw "extrafiles is unmaintained since 2020 and broken since beets 2.0.0";
})
