{
  lib,
  appimageTools,
  buildFHSEnv,
  makeDesktopItem,
  extraPkgs ? pkgs: [ ],
  appimage-run-tests ? null,
}:

buildFHSEnv (
  lib.recursiveUpdate appimageTools.defaultFhsEnvArgs rec {
    name = "appimage-run";

    desktopItem = makeDesktopItem {
      name = "appimage-run";
      exec = "appimage-run";
      desktopName = "appimage-run";
      genericName = "AppImage runner";
      noDisplay = true;
      mimeTypes = [
        "application/vnd.appimage"
        "application/x-iso9660-appimage"
      ];
      categories = [
        "PackageManager"
        "Utility"
      ];
    };

    targetPkgs =
      pkgs:
      [ appimageTools.appimage-exec ]
      ++ appimageTools.defaultFhsEnvArgs.targetPkgs pkgs
      ++ extraPkgs pkgs;

    runScript = "appimage-exec.sh";

    extraInstallCommands = ''
      cp --recursive "${desktopItem}/share" "$out/"
    '';

    passthru.tests.appimage-run = appimage-run-tests;

    meta.mainProgram = "appimage-run";
  }
)
