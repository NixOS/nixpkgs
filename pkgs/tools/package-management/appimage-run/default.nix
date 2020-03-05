{ buildFHSUserEnv, coreutils, file, libarchive, runtimeShell
, extraPkgs ? pkgs: [], appimageTools, stdenv, bash }:

let

  name = "appimage-run";
  version = "1.0";
  fhsArgs = appimageTools.defaultFhsEnvArgs;

  appimage-exec = stdenv.mkDerivation {
     #inherit pname version;
     name = "appimage-exec";

     inherit coreutils file libarchive bash;

     buildCommand = ''
       mkdir -p $out/bin/
       substituteAll ${./appimage-exec.sh} $out/bin/appimage-exec.sh
       chmod +x $out/bin/appimage-exec.sh
    '';
  };

in buildFHSUserEnv (fhsArgs // {
  inherit name;

  targetPkgs = pkgs:
    [ appimage-exec
    ] ++ fhsArgs.targetPkgs pkgs ++ extraPkgs pkgs;
  #extraInstallCommands = '''';
  runScript = "appimage-exec.sh";
})
