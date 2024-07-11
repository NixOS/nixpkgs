{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "shorter-pixel-dungeon";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Shorter-Pixel-Dungeon";
    rev = "Short-${version}";
    hash = "sha256-iG90T/Ho8/JY3HgkACiBnGdbUGsVRlfxXbcNFHhzZi4=";
  };

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail "gdxControllersVersion = '2.2.4-SNAPSHOT'" "gdxControllersVersion = '2.2.3'"
  '';

  depsHash = "sha256-PyBEhlOOVD3/YH4SWs1yMkdg3U96znk1/VV6SAr8S30=";

  desktopName = "Shorter Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Shorter-Pixel-Dungeon/releases";
    description = "A shorter fork of the Shattered Pixel Dungeon roguelike";
  };
}
