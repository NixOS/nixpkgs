{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "shorter-pixel-dungeon";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Shorter-Pixel-Dungeon";
    rev = "Short-${version}";
    hash = "sha256-8vmh65XlNqfIh4WHLPuWU68tb3ajKI8kBMI68CYlsSk=";
  };

  depsPath = "deps-shorter.json";

  desktopName = "Shorter Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon/releases";
    description = "A shorter fork of the Shattered Pixel Dungeon roguelike";
  };
}
