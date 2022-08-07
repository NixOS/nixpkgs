{ lib
, callPackage
, fetchFromGitHub
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
  };

  beets-minimal = self.beets.override { disableAllPlugins = true; };

  beets-unstable = callPackage ./common.nix {
    version = "unstable-2022-05-08";
    src = fetchFromGitHub {
      owner = "beetbox";
      repo = "beets";
      rev = "e06cf7969bfdfa4773049699320471be45d56054";
      hash = "sha256-yWwxYSzSSmx2UfCn0EBH23hQGZKSRn/c8ryvxLUeHdM=";
    };
    pluginOverrides = {
      # unstable has a new plugin, so we register it here.
      limit = { builtin = true; };
    };
  };

  alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
  copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
  extrafiles = callPackage ./plugins/extrafiles.nix { beets = self.beets-minimal; };
})
