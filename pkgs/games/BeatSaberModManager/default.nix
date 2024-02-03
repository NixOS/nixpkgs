{
  lib,
  stdenv,
  substituteAll,

  dotnet_7,
  dotnet_6,
  fetchFromGitHub,

  libX11,
  libICE,
  libSM,
  fontconfig,

  xdg-utils,
}:
let
  dotnet = dotnet_7.withExtraSDKs [ dotnet_6.sdk ];

in dotnet.buildDotnetModule rec {
  pname = "BeatSaberModManager";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "affederaffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HHWC+MAwJ+AMCuBzSuR7FbW3k+wLri0B9J1DftyfNEU=";
    fetchSubmodules = true; # It vendors BSIPA-Linux
  };

  projectFile = [ "BeatSaberModManager/BeatSaberModManager.csproj" ];

  executables = [ "BeatSaberModManager" ];

  nugetDeps = ./deps.nix;

  runtimeDeps = [
    libX11
    libICE
    libSM
    fontconfig
  ];

  # Required for OneClick
  makeWrapperArgs = [
    ''--suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"''
  ];

  meta = with lib; {
    description = "Yet another mod installer for Beat Saber, heavily inspired by ModAssistant";
    homepage = "https://github.com/affederaffe/BeatSaberModManager";
    longDescription = ''
      BeatSaberModManager is yet another mod installer for Beat Saber, heavily inspired by ModAssistant
      It strives to look more visually appealing and support both Windows and Linux, while still being as feature-rich as ModAssistant.

      Features

      - Windows and Linux support
      - Dependency resolution
      - Installed mod detection
      - Mod uninstallation
      - Theming support
      - OneClick™ support for BeatSaver, ModelSaber and Playlists
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ atemu ];
    platforms = with platforms; linux;
  };
}
