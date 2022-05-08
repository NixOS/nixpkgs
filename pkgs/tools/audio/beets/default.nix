{ lib
, callPackage
, fetchFromGitHub
}:

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
      limit = { };
    };
  };

  alternatives = callPackage ./plugins/alternatives.nix { beets = self.beets-minimal; };
  copyartifacts = callPackage ./plugins/copyartifacts.nix { beets = self.beets-minimal; };
  extrafiles = callPackage ./plugins/extrafiles.nix { beets = self.beets-minimal; };
})
