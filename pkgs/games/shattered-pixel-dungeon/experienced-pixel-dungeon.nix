{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix rec {
  pname = "experienced-pixel-dungeon";
  version = "2.18";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Experienced-Pixel-Dungeon-Redone";
    rev = "ExpPD-${version}";
    hash = "sha256-jOKHBd9LaDn3oqLdQWqAcJnicktlbkDGw00nT8JveoI=";
  };

  postPatch = ''
    substituteInPlace build.gradle \
      --replace-fail "gdxControllersVersion = '2.2.4-SNAPSHOT'" "gdxControllersVersion = '2.2.3'"
  '';

  depsHash = "sha256-PyBEhlOOVD3/YH4SWs1yMkdg3U96znk1/VV6SAr8S30=";

  desktopName = "Experienced Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone";
    downloadPage = "https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone/releases";
    description = "A fork of the Shattered Pixel Dungeon roguelike without limits on experience and items";
  };
}
