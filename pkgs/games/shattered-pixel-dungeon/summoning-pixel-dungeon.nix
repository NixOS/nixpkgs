{ callPackage
, fetchFromGitHub
, gradle_6
, substitute
}:

callPackage ./generic.nix rec {
  pname = "summoning-pixel-dungeon";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Summoning-Pixel-Dungeon";
    # The GH release is named "$version-$hash", but it's actually a mutable "_latest" tag
    rev = "fc63a89a0f9bdf9cb86a750dfec65bc56d9fddcb";
    hash = "sha256-n1YR7jYJ8TQFe654aERgmOHRgaPZ82eXxu0K12/5MGw=";
  };

  patches = [(substitute {
    src = ./disable-git-version.patch;
    replacements = [ "--subst-var-by" "version" version ];
  })];

  depsHash = "sha256-0P/BcjNnbDN25DguRcCyzPuUG7bouxEx1ySodIbSwvg=";

  desktopName = "Summoning Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon/releases";
    description = "A fork of the Shattered Pixel Dungeon roguelike with added summoning mechanics";
  };

  # Probably due to https://github.com/gradle/gradle/issues/17236
  gradle = gradle_6;
}
