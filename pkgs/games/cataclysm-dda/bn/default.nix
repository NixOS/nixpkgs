{
  lib,
  mkCataclysm,
  fetchFromGitHub,
  sqlite,
}:

mkCataclysm (finalAttrs: {
  pname = "cataclysm-bright-nights";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cataclysmbnteam";
    repo = "Cataclysm-BN";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OKxYJKeSPGus9zbRsCbNIXx+qc27Ae/Se6oeFAGMHUY=";
  };

  versionFile = ''
    build type: nixpkgs
    build number: ${finalAttrs.version}
    commit sha: ${finalAttrs.src.rev}
    commit url: ${finalAttrs.src.resolvedUrl}
  '';

  postPatch = ''
    # Remove broken symlinks
    rm data/json/external_tileset/README.md
    rm data/json/mapgen/lab/README.md

    # Fix build failure since git is not used
    echo "$versionFile" > VERSION.txt
  '';

  useCmake = true;

  buildInputs = [
    sqlite
  ];

  meta = {
    homepage = "https://docs.cataclysmbn.org/";
    changelog = "https://github.com/cataclysmbnteam/Cataclysm-BN/releases/tag/v${finalAttrs.version}";
    description = "roguelike with sci-fi elements set in a post-apocalyptic world";
  };
})
