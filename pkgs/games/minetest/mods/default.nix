{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let buildMod = (import ./build-minetest-mod.nix { inherit stdenv; }).buildMinetestMod;
in
{

  creaturaMod = buildMod {
    pname = "creatura";
    src = fetchTarball {
      url = "https://github.com/ElCeejo/creatura/tarball/ce14c859249fa62d52fe54fcec297150ef159000";
      sha256 = "1hxhgh5m0b0v2fv89z63ajgc48i41fv10p5il5zg43qjsqcbjlf6";
    };
  };

  animaliaMod = buildMod {
    pname = "animalia";
    src = fetchFromGitHub {
      owner = "ElCeejo";
      repo = "animalia";
      rev = "325dc1609ac2dc3b6d07dd4a2344380f9667c199";
      sha256 = "0hpxws26bzx2d3vdi9555yv48lvbvyanq76jxpzrc6k5jvvhzqgp";
    };
  };

  creaturesMod = buildMod {
    pname = "creatures";
    src = fetchGit {
      url = "https://github.com/MirceaKitsune/minetest_mods_creatures.git";
      rev = "adca784b964f28f7393669b3da71c99750099e7b";
    };
  };

  zombiesMod = buildMod {
    pname = "zombies";
    src = fetchGit {
      url = "https://github.com/minetest-mods/zombies.git";
      rev = "0e633a5b1c7174e73c57cb2cdd676470eab9d627";
    };
  };
  cityscapeMod = buildMod {
    pname = "cityscape";
    src = fetchGit {
      url = "https://github.com/duane-r/cityscape.git";
      rev = "06009a08044bc93798ed388b44d65d1ce96a8e2f";
    };
  };
  whitelistMod = buildMod {
    pname = "whitelist";
    src = fetchGit {
      url = "https://github.com/ShadowNinja/whitelist.git";
      rev = "041737f01989ccdfa200e5eaa78547fd4bf12f2d";
    };
  };

  draconisMod = buildMod {
    pname = "draconis";
    src = fetchTarball {
      url = "https://github.com/ElCeejo/draconis/tarball/dca26827e70171eb7a0e7c59058b52768daa0ef6";
      sha256 = "0mlx0qib6qyana272wn43mwhgdgyakn1n7xjqbnm1gizzf8i101i";
    };
  };

  wieldedLightMod = buildMod {
    pname = "wielded_light";
    src = fetchGit {
      url = "https://github.com/minetest-mods/wielded_light.git";
      rev = "b5236562af9772dff8522fe2bda5b5f738e81b88";
    };
  };
}
