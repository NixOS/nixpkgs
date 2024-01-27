{ callPackage
, fetchFromGitHub
, nixosTests
}:

callPackage ./generic.nix rec {
  pname = "shattered-pixel-dungeon";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
    rev = "v${version}";
    hash = "sha256-PUAHsFW8rb4SZlZKCIx6SO3U7I7uJgfUal2VXzUjQNs=";
  };

  depsHash = "sha256-QfAV6LYD6S/8ptaqqKSDtOe4kStwp6LJp8WVc3sH8yc=";

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
