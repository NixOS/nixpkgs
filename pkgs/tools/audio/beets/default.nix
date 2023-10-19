{ lib
, callPackage
, fetchFromGitHub
, fetchpatch
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
    version = "1.6.0";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "v${version}";
      hash = "sha256-fT+rCJJQR7bdfAcmeFRaknmh4ZOP4RCx8MXpq7/D8tM=";
    };
    extraPatches = [
      # Bash completion fix for Nix
      ./patches/bash-completion-always-print.patch

      # Fix unidecode>=1.3.5 compat
      (fetchpatch {
        url = "https://github.com/beetbox/beets/commit/5ae1e0f3c8d3a450cb39f7933aa49bb78c2bc0d9.patch";
        hash = "sha256-gqkrE+U1j3tt1qPRJufTGS/GftaSw/gweXunO/mCVG8=";
      })

      # Fix embedart with ImageMagick 7.1.1-12
      # https://github.com/beetbox/beets/pull/4839
      # The upstream patch does not apply on 1.6.0, as the related code has been refactored since
      ./patches/fix-embedart-imagick-7.1.1-12.patch
    ];
  };

  beets-minimal = self.beets.override { disableAllPlugins = true; };

  beets-unstable = callPackage ./common.nix {
    version = "unstable-2023-07-05";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "9481402b3c20739ca0b879d19adbfca22ccd6a44";
      hash = "sha256-AKmozMNVchysoQcUWd90Ic6bQBKQgylVn0E3i85dGb8=";
    };
    extraPatches = [
      # Bash completion fix for Nix
      ./patches/unstable-bash-completion-always-print.patch
    ];
    pluginOverrides = {
      # unstable has a new plugin, so we register it here.
      limit = { builtin = true; };
    };
  };

  alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
  copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
  extrafiles = callPackage ./plugins/extrafiles.nix { beets = self.beets-minimal; };
})
