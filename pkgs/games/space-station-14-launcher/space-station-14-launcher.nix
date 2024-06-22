{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, wrapGAppsHook3
, iconConvTools
, copyDesktopItems
, makeDesktopItem
, libX11
, libICE
, libSM
, libXi
, libXcursor
, libXext
, libXrandr
, fontconfig
, glew
, SDL2
, glfw
, glibc
, libGL
, freetype
, openal
, fluidsynth
, gtk3
, pango
, atk
, cairo
, zlib
, glib
, gdk-pixbuf
}:
let
  version = "0.27.2";
  pname = "space-station-14-launcher";
in
buildDotnetModule rec {
  inherit pname;

  # Workaround to prevent buildDotnetModule from overriding assembly versions.
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "space-wizards";
    repo = "SS14.Launcher";
    rev = "v${version}";
    hash = "sha256-r+nNZ2xkHMp8bmNNqbf4WnmGP3SIxCtHUCfGxfydTH4=";
    fetchSubmodules = true;
  };

  buildType = "Release";
  selfContainedBuild = false;

  projectFile = [
    "SS14.Loader/SS14.Loader.csproj"
    "SS14.Launcher/SS14.Launcher.csproj"
  ];

  nugetDeps = ./deps.nix;

  passthru = {
    inherit version; # Workaround so update script works.
    updateScript = ./update.sh;
  };

  # SDK 6.0 required for Robust.LoaderApi
  dotnet-sdk = with dotnetCorePackages; combinePackages [ sdk_8_0 sdk_6_0 ];
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  dotnetFlags = [
    "-p:FullRelease=true"
    "-p:RobustILLink=true"
    "-nologo"
  ];

  nativeBuildInputs = [ wrapGAppsHook3 iconConvTools copyDesktopItems ];

  runtimeDeps = [
    # Required by the game.
    glfw
    SDL2
    glibc
    libGL
    openal
    freetype
    fluidsynth

    # Needed for file dialogs.
    gtk3
    pango
    cairo
    atk
    zlib
    glib
    gdk-pixbuf

    # Avalonia UI dependencies.
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew
  ];

  executables = [ "SS14.Launcher" ];

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = meta.mainProgram;
      icon = pname;
      desktopName = "Space Station 14 Launcher";
      comment = meta.description;
      categories = [ "Game" ];
      startupWMClass = meta.mainProgram;
    })
  ];

  postInstall = ''
    mkdir -p $out/lib/space-station-14-launcher/loader
    cp -r SS14.Loader/bin/${buildType}/*/*/* $out/lib/space-station-14-launcher/loader/

    icoFileToHiColorTheme SS14.Launcher/Assets/icon.ico space-station-14-launcher $out
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Launcher for Space Station 14, a multiplayer game about paranoia and disaster";
    homepage = "https://spacestation14.io";
    license = licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "SS14.Launcher";
  };
}
