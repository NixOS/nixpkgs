{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages, SDL2, libsecret, glib, gnutls, aria2, steam-run
, copyDesktopItems, makeDesktopItem
, useSteamRun ? true }:

let
  rev = "6246fde6b54f8c7e340057fe2d940287c437153f";
in
  buildDotnetModule rec {
    pname = "XIVLauncher";
    version = "1.0.1.0";

    src = fetchFromGitHub {
      owner = "goatcorp";
      repo = "FFXIVQuickLauncher";
      inherit rev;
      sha256 = "sha256-sM909/ysrlwsiVSBrMo4cOZUWxjRA3ZSwlloGythOAY=";
    };

    nativeBuildInputs = [ copyDesktopItems ];

    projectFile = "src/XIVLauncher.Core/XIVLauncher.Core.csproj";
    nugetDeps = ./deps.nix; # File generated with `nix-build -A xivlauncher.passthru.fetch-deps`

    dotnetFlags = [
      "--runtime linux-x64"
      "-p:BuildHash=${rev}"
    ];

    dotnetBuildFlags = [
      "--no-self-contained"
    ];

    postPatch = ''
      substituteInPlace src/XIVLauncher.Common/Game/Patch/Acquisition/Aria/AriaHttpPatchAcquisition.cs \
        --replace 'ariaPath = "aria2c"' 'ariaPath = "${aria2}/bin/aria2c"'
    '';

    postInstall = ''
      mkdir -p $out/share/pixmaps
      cp src/XIVLauncher.Core/Resources/logo.png $out/share/pixmaps/xivlauncher.png
    '';

    postFixup = lib.optionalString useSteamRun ''
      substituteInPlace $out/bin/XIVLauncher.Core \
        --replace 'exec' 'exec ${steam-run}/bin/steam-run'
    '';

    executables = [ "XIVLauncher.Core" ];

    runtimeDeps = [ SDL2 libsecret glib gnutls ];

    desktopItems = [
      (makeDesktopItem {
        name = "xivlauncher";
        exec = "XIVLauncher.Core";
        icon = "xivlauncher";
        desktopName = "XIVLauncher";
        comment = meta.description;
        categories = [ "Game" ];
      })
    ];

    meta = with lib; {
      description = "Custom launcher for FFXIV";
      homepage = "https://github.com/goatcorp/FFXIVQuickLauncher";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ashkitten sersorrel ];
      platforms = [ "x86_64-linux" ];
    };
  }
