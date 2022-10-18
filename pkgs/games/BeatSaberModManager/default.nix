{
  lib,

  buildDotnetModule,
  fetchFromGitHub,

  libX11,
  libICE,
  libSM,
  fontconfig,
}:

buildDotnetModule rec {
  pname = "BeatSaberModManager";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "affederaffe";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6+9pWr8jJzs430Ai2ddh/2DK3C2bQA1e1+BNDrKhyzY=";
    fetchSubmodules = true; # It vendors BSIPA-Linux
  };

  nugetDeps = ./deps.nix;

  dotnetInstallFlags = [
    # FIXME It doesn't like that for some reason beyond my ability to package dotnet
    "-p:PublishSingleFile=false"
  ];

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
