{
  callPackage,
  fetchFromGitHub,
  nixosTests,
}:

callPackage ./generic.nix rec {
  pname = "shattered-pixel-dungeon";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
    rev = "v${version}";
    hash = "sha256-MUpQdH8RMzZtI6e2duSRWHK1gPJDhMRKsm5kIKDcFuk=";
  };

  depsPath = ./deps.json;

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
