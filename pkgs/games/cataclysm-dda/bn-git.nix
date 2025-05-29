{ lib, callPackage, fetchFromGitHub, fetchpatch, pkgs, wrapCDDA, attachPkgs
, tiles ? true
, debug ? false
, useXdgDir ? false
, version ? "v0.8.0-unstable-2025-05-17"
, rev ? "4192d73997fa78a05e06b99fae8e34dd021226c5"
, sha256 ? "sha256-jeyyJw5tkgvVgvpnDj5XkobzP8NBMd0YFk2ShTRcd9U="
}:

let
  desktopFilePath = "";

  common = callPackage ./common.nix {
    inherit tiles debug useXdgDir desktopFilePath;
  };

  self = common.overrideAttrs (common: rec {
    pname = "cataclysm-bn-git";
    inherit version;

    src = fetchFromGitHub {
      owner = "cataclysmbnteam";
      repo = "Cataclysm-BN";
      inherit rev sha256;
    };

    patches = [
      # Unfortunately some READMEs in data are symlinks to doc which is not included
      # resulting in dangling symlinks breaking build
      ./delete-dangling-readme.patch
    ];

    makeFlags = common.makeFlags ++ [
      "VERSION=git-${version}-${lib.substring 0 8 src.rev}"
    ];

    meta = common.meta // {
      description = "Roguelike with sci-fi elements set in a post-apocalyptic world";
      longDescription = ''
        Cataclysm: Bright Nights is a roguelike with sci-fi elements set in a
        post-apocalyptic world, a fork of Cataclysm: Dark Days Ahead.

        While some have described it as a "zombie game", there is far more to
        Cataclysm than that. Struggle to survive in a harsh, persistent,
        procedurally generated world. Scavenge the remnants of a dead
        civilization for food, equipment, or, if you are lucky, a vehicle with a
        full tank of gas to get you the hell out of there.

        Fight to defeat or escape from a wide variety of powerful monstrosities,
        from zombies to giant insects to killer robots and things far stranger
        and deadlier, and against the others like yourself, who want what you
        have.

        Find a way to stop the Cataclysm ... or become one of its strongest
        monsters.
      '';
      homepage = "https://cataclysmbn.org/";
      maintainers = with lib.maintainers; common.meta.maintainers ++ [ caryoscelus ];
    };
  });
in

attachPkgs pkgs self
