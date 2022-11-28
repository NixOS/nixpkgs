{pkgs}:
let
  version = "1.6.14";
in
pkgs.mkYarnPackage {
  name = "vortex";

  src = pkgs.fetchFromGitHub {
    owner = "Nexus-Mods";
    repo = "Vortex";
    rev = "v${version}";
    sha256 = "sha256-X18lyVUMPlP+dkBXcqDimQlwUWVBg6PmoDbBPoO5LUs=";
    fetchSubmodules = true;
  };

  yarnPreBuild = ''
    yarn config set msvs_version 2022
  '';

  extraBuildInputs = [
    pkgs.python3
  ];

  meta = {
    description = "Mod manager";
    homepage = "https://www.nexusmods.com/site/mods/1";
    changelog = "https://github.com/Nexus-Mods/Vortex/releases/tag/v${version}";
    license = pkgs.lib.licenses.gpl3Only;
    maintainers = [
      pkgs.lib.maintainers.l0b0
    ];
  };
}
