{
  callPackage,
  fetchFromGitHub,
  gradle_6,
  substitute,
}:

callPackage ../generic.nix rec {
  pname = "summoning-pixel-dungeon";
  version = "1.2.5a";

  src = fetchFromGitHub {
    owner = "TrashboxBobylev";
    repo = "Summoning-Pixel-Dungeon";
    # The GH release is named "$version-$hash", but it's actually a mutable "_latest" tag
    rev = "89ff59e7f42abcc88b7a1f24391f95ddc30f9d29";
    hash = "sha256-VQcWkbGe/0qyt3M5WWgTxczwC5mE3lRHbYidOwRoukI=";
  };

  patches = [
    (substitute {
      src = ./disable-git-version.patch;
      substitutions = [
        "--subst-var-by"
        "version"
        version
      ];
    })
  ];

  desktopName = "Summoning Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon/releases";
    description = "A fork of the Shattered Pixel Dungeon roguelike with added summoning mechanics";
  };

  # Probably due to https://github.com/gradle/gradle/issues/17236
  gradle = gradle_6;
}
