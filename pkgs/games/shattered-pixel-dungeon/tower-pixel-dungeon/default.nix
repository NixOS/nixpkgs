{
  lib,
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "tower-pixel-dungeon";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "FixAkaTheFix";
    repo = "Tower-Pixel-Dungeon";
    tag = "TPDv${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-6b7EC7rye7nSevMJhRwSKJU7zuzta6KUCgzizWPFk8I=";
  };

  sourceRoot = src.name + "/pixel-towers-master";

  desktopName = "Tower Pixel Dungeon";

  # Sprite sources (Paint.NET files) and other files interfere with the build process.
  postPatch = ''
    rm core/src/main/assets/{levelsplashes,sprites}/*.pdn
    rm core/src/main/assets/environment/*.lnk
  '';

  meta = {
    homepage = "https://github.com/FixAkaTheFix/Tower-Pixel-Dungeon";
    downloadPage = "https://github.com/FixAkaTheFix/Tower-Pixel-Dungeon/releases";
    description = "Turn-based tower defense game based on Shattered Pixel Dungeon";
  };
}
