{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "experienced-pixel-dungeon";
  version = "2.18.2";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Experienced-Pixel-Dungeon-Redone";
    rev = "ExpPD-${version}";
    hash = "sha256-REBltg7rKgrNSKHh3QuG8XVLPivS1fAtyqf/TRjH0W0=";
  };

  desktopName = "Experienced Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone";
    downloadPage = "https://github.com/TrashboxBobylev/Experienced-Pixel-Dungeon-Redone/releases";
    description = "A fork of the Shattered Pixel Dungeon roguelike without limits on experience and items";
  };
}
