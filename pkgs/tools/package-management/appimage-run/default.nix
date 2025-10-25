{
  lib,
  appimageTools,
  buildFHSEnv,
  makeDesktopItem,
  extraPkgs ? [ ],
  appimage-run-tests ? null,
}:

let
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
in
buildFHSEnv (
  lib.recursiveUpdate appimageTools.defaultFhsEnvArgs {
    name = "appimage-run";

    targetPkgs =
      pkgs:
      [ appimageTools.appimage-exec ] ++ appimageTools.defaultFhsEnvArgs.targetPkgs pkgs ++ extraPkgs;

    runScript = "appimage-exec.sh";

    extraInstallCommands = ''
      cp --recursive "${desktopItem}/share" "$out/"
    '';

    passthru.tests.appimage-run = appimage-run-tests;

    meta.mainProgram = "appimage-run";
  }
)
