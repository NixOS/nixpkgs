{ lib, buildDotnetModule, fetchFromGitHub, dotnetCorePackages, SDL2, libsecret, glib, gnutls, aria2, steam-run
, copyDesktopItems, makeDesktopItem
, useSteamRun ? true }:

let
  rev = "1.0.2";
in
  buildDotnetModule rec {
    pname = "XIVLauncher";
    version = rev;

    src = fetchFromGitHub {
      owner = "goatcorp";
      repo = "XIVLauncher.Core";
      inherit rev;
      sha256 = "DlSMxIbgzL5cy+A5nm7ZaA2A0TdINtq2GHW27uxORKI=";
      fetchSubmodules = true;
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
      substituteInPlace lib/FFXIVQuickLauncher/src/XIVLauncher.Common/Game/Patch/Acquisition/Aria/AriaHttpPatchAcquisition.cs \
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
        startupWMClass = "XIVLauncher.Core";
      })
    ];

    meta = with lib; {
      description = "Custom launcher for FFXIV";
      homepage = "https://github.com/goatcorp/FFXIVQuickLauncher";
      license = licenses.gpl3;
      maintainers = with maintainers; [ ashkitten sersorrel ];
      platforms = [ "x86_64-linux" ];
      mainProgram = "XIVLauncher.Core";
    };
  }
