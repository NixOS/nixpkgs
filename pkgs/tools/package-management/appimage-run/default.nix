{ appimageTools, buildFHSUserEnv, extraPkgs ? pkgs: [] }:

let
  fhsArgs = appimageTools.defaultFhsEnvArgs;
in buildFHSUserEnv (fhsArgs // {
  name = "appimage-run";

  targetPkgs = pkgs: [ appimageTools.appimage-exec ]
    ++ fhsArgs.targetPkgs pkgs ++ extraPkgs pkgs;
  runScript = "appimage-exec.sh";
})
