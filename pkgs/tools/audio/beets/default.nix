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
      # Fix embedart with ImageMagick 7.1.1-12
      # https://github.com/beetbox/beets/pull/4839
      # The upstream patch does not apply on 1.6.0, as the related code has been refactored since
      ./patches/stable-fix-embedart-imagick-7.1.1-12.patch
    ];
  };

  beets-minimal = self.beets.override { disableAllPlugins = true; };

  beets-unstable = callPackage ./common.nix {
    version = "unstable-2022-08-27";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "50bd693057de472470ab5175fae0cdb5b75811c6";
      hash = "sha256-91v1StaByG60ryhQqByBXu6sFCjk0qT0nsUPnocSEE4=";
    };
    extraPatches = [
      (fetchpatch {
        # Fix embedart with ImageMagick 7.1.1-12
        # https://github.com/beetbox/beets/pull/4839
        name = "fix-embedart-imagick-7.1.1-12.patch";
        url = "https://github.com/beetbox/beets/commit/a873a191b9d25236774cec82df2ceb6399ed4ce3.patch";
        hash = "sha256-1b3igHx0jKQkyVUlwOx6Oo3O1f3w8oZDw4xpHFw0DO0=";
      })
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
