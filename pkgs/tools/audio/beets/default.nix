{ lib
, callPackage
, fetchFromGitHub
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
      # Pillow 10 compatibility fix, a backport of
      # https://github.com/beetbox/beets/pull/4868, which doesn't apply now
      ./patches/fix-pillow10-compat.patch

      # Sphinx 6 compatibility fix.
      (fetchpatch {
        url = "https://github.com/beetbox/beets/commit/2106f471affd1dab35b4b26187b9c74d034528c5.patch";
        hash = "sha256-V/886dYJW/O55VqU8sd+x/URIFcKhP6j5sUhTGMoxL8=";
      })
    ];
    disabledTests = [
      # This issue is present on this version alone, and can be removed on the
      # next stable version version bump. Since this is fixed in branch master,
      # we don't have a bug ticket open for this. As of writing, it also seems
      # hard to find a patch that can be backported to v1.6.0 that would fix
      # the failure, as the master branch has gone through too many changes
      # now.
      "test_get_single_item_by_path"
    ];
  };

  beets-minimal = self.beets.override { disableAllPlugins = true; };

  beets-unstable = callPackage ./common.nix {
    inherit python3Packages;
    version = "unstable-2023-10-26";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "6655760732100f5387fad2d2890c015ee5039981";
      hash = "sha256-Nz9BHtacYpJMLmB3f9WFg6GvMa+BuUhiNbJ9cyannek=";
    };
    extraPatches = [
      # Bash completion fix for Nix
      ./patches/unstable-bash-completion-always-print.patch
    ];
    pluginOverrides = {
      # unstable has new plugins, so we register them here.
      limit = { builtin = true; };
      substitute = { builtin = true; };
      advancedrewrite = { builtin = true; };
      autobpm = { builtin = true; };
    };
    extraNativeBuildInputs = [
      python3Packages.pydata-sphinx-theme
    ];
  };

  alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
  copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
  extrafiles = callPackage ./plugins/extrafiles.nix { beets = self.beets-minimal; };
})
