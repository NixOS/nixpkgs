{ appimageTools, buildFHSUserEnv, extraPkgs ? pkgs: [], appimage-run-tests ? null }:

let
  fhsArgs = appimageTools.defaultFhsEnvArgs;
in buildFHSUserEnv (fhsArgs // {
  name = "appimage-run";

  targetPkgs = pkgs: [ appimageTools.appimage-exec ]
    ++ fhsArgs.targetPkgs pkgs ++ extraPkgs pkgs;
  runScript = "appimage-exec.sh";

  passthru.tests.appimage-run = appimage-run-tests;
})
