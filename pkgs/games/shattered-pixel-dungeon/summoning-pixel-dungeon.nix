{
  callPackage,
  fetchFromGitHub,
  fetchpatch,
  substitute,
}:

callPackage ./generic.nix rec {
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
    # FIXME: Remove after next release
    (fetchpatch {
      name = "Update-desktop-build-script-for-Gradle-7.0+";
      url = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon/commit/5610142126e161cbdc78a07c5d5abfbcd6eaf8a6.patch";
      hash = "sha256-zAiOz/Cu89Y+VmAyLCf7fzq0Mr0sYFZu14sqBZ/XvZU=";
    })
  ];

  postPatch = ''
    # Upstream patched this in https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon/commit/c8a6fdd57c49fd91bf65be48679ae6a77578ef9f,
    # but the patch fails to apply cleanly. Manually replace the deprecated option instead.
    # FIXME: Remove after next release
    substituteInPlace gradle.properties \
      --replace-fail "-XX:MaxPermSize" "-XX:MaxMetaspaceSize"
  '';

  depsHash = "sha256-0P/BcjNnbDN25DguRcCyzPuUG7bouxEx1ySodIbSwvg=";

  desktopName = "Summoning Pixel Dungeon";

  meta = {
    homepage = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon";
    downloadPage = "https://github.com/TrashboxBobylev/Summoning-Pixel-Dungeon/releases";
    description = "A fork of the Shattered Pixel Dungeon roguelike with added summoning mechanics";
  };
}
