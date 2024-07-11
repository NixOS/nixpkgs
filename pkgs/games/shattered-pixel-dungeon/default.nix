{ callPackage
, fetchFromGitHub
, nixosTests
}:

callPackage ./generic.nix rec {
  pname = "shattered-pixel-dungeon";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
    rev = "v${version}";
    hash = "sha256-1msmjKDEd/pFMqLB4vJgR6GPC9z4CnNew2hlemLw2d0=";
  };

  depsHash = "sha256-vihoR0bPh7590sRxeYJ1uuynNRxtRBuiFUrdmsRNUJc=";

  passthru.tests = {
    shattered-pixel-dungeon-starts = nixosTests.shattered-pixel-dungeon;
  };

  desktopName = "Shattered Pixel Dungeon";

  meta = {
    homepage = "https://shatteredpixel.com/";
    downloadPage = "https://github.com/00-Evan/shattered-pixel-dungeon/releases";
    description = "Traditional roguelike game with pixel-art graphics and simple interface";
  };
}
