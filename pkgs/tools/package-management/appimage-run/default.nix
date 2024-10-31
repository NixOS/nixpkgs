{ lib
, appimageTools
, buildFHSEnv
, makeDesktopItem
, extraPkgs ? pkgs: []
, appimage-run-tests ? null
}:

let
  name = "appimage-run";

  fhsArgs = appimageTools.defaultFhsEnvArgs;

  desktopItem = makeDesktopItem {
    inherit name;
    exec = name;
    desktopName = name;
    genericName = "AppImage runner";
    noDisplay = true;
    mimeTypes = ["application/vnd.appimage" "application/x-iso9660-appimage"];
    categories = ["PackageManager" "Utility"];
  };
in buildFHSEnv (lib.recursiveUpdate fhsArgs {
  inherit name;

  targetPkgs = pkgs: [ appimageTools.appimage-exec ]
    ++ fhsArgs.targetPkgs pkgs ++ extraPkgs pkgs;
  runScript = "appimage-exec.sh";

  extraInstallCommands = ''
    cp --recursive "${desktopItem}/share" "$out/"
  '';

  passthru.tests.appimage-run = appimage-run-tests;

  meta.mainProgram = "appimage-run";
})
