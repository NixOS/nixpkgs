{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "rkpd2";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "Zrp200";
    repo = "rkpd2";
    rev = "v${version}";
    hash = "sha256-VVqwgwDuIyRd5MU1/64Xz+8TbIOrXcHufs0XqD/Q4ls=";
  };

  depsHash = "sha256-vihoR0bPh7590sRxeYJ1uuynNRxtRBuiFUrdmsRNUJc=";

  desktopName = "Rat King Pixel Dungeon 2";

  meta = {
    homepage = "https://github.com/Zrp200/rkpd2";
    downloadPage = "https://github.com/Zrp200/rkpd2/releases";
    description = "Fork of popular roguelike game Shattered Pixel Dungeon that drastically buffs heroes and thus makes the game significantly easier";
  };
}
