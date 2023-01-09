{
  lib,
  dotnet-sdk,
  stdenv,
  substituteAll,

  buildDotnetModule,
  fetchFromGitHub,

  dotnetCorePackages,

  libX11,
  libICE,
  libSM,
  fontconfig,
}:

buildDotnetModule rec {
  pname = "BeatSaberModManager";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "affederaffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XeyOWg4Wa4hiorLPnbnBrLSjnxheAGGMPTqBleulDGw=";
    fetchSubmodules = true; # It vendors BSIPA-Linux
  };

  # This _must_ be specified in the project file and it can only be one so
  # obviously you wouldn't specify it as an upstream project. Typical M$.
  # https://github.com/NixOS/nixpkgs/pull/196648#discussion_r998709996
  # https://github.com/affederaffe/BeatSaberModManager/issues/5
  patches = [
    (substituteAll {
      src = ./add-runtime-identifier.patch;
      runtimeIdentifier = dotnetCorePackages.systemToDotnetRid stdenv.targetPlatform.system;
    })
  ];

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  nugetDeps = ./deps.nix;

  runtimeDeps = [
    libX11
    libICE
    libSM
    fontconfig
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
