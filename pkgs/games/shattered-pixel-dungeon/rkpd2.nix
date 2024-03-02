{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "rkpd2";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Zrp200";
    repo = "rkpd2";
    rev = "v${version}";
    hash = "sha256-3WKQCXFDyliObXaIRp3x0kRh3XeNd24SCoTgdFA8/rM=";
  };

  depsHash = "sha256-yE6zuLnFLtNq76AhtyE+giGLF2vcCqF7sfIvcY8W6Lg=";

  desktopName = "Rat King Pixel Dungeon 2";

  meta = {
    homepage = "https://github.com/Zrp200/rkpd2";
    downloadPage = "https://github.com/Zrp200/rkpd2/releases";
    description = "Fork of popular roguelike game Shattered Pixel Dungeon that drastically buffs heroes and thus makes the game significantly easier";
  };
}
