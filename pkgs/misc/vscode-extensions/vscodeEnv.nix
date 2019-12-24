#use vscodeWithConfiguration and vscodeExts2nix to create vscode exetuable that when exits(vscode) will update the mutable extension file, which is imported when getting evaluated by nix.
{ pkgs                            ? import <nixpkgs> {}
, lib                             ? pkgs.lib
, writeShellScriptBin             ? pkgs.writeShellScriptBin
, extensionsFromVscodeMarketplace ? pkgs.vscode-utils.extensionsFromVscodeMarketplace

##User input

, nixExtensions                   ? []
# if file exists will use it and import the extensions in it into this dervation else will use empty extensions list
# this file will be created/updated by vscodeExts2nix when vscode exists
, mutableExtensionsFile           ? ./extensions.nix
, vscodeExtsFolderName            ? ".vscode-exts"
, vscode                          ? pkgs.vscode
}:
let  
  mutableExtensionsFilePath = builtins.toPath mutableExtensionsFile;
  mutableExtensions = if builtins.pathExists mutableExtensionsFile 
                      then import mutableExtensionsFilePath else [];
  vscodeWithConfiguration = import ./vscodeWithConfiguration.nix { 
    inherit lib writeShellScriptBin vscode extensionsFromVscodeMarketplace 
    nixExtensions mutableExtensions vscodeExtsFolderName;
  };

  vscodeExts2nix = import ./vscodeExts2nix.nix { 
    inherit lib writeShellScriptBin;
    extensionsToIgnore = nixExtensions;
    extensions = mutableExtensions; 
    vscode = vscodeWithConfiguration;
  };
  code = writeShellScriptBin "code" ''
    ${vscodeWithConfiguration}/bin/code --wait "$@" 
    echo 'running vscodeExts2nix to update ${mutableExtensionsFilePath}...'
    ${vscodeExts2nix}/bin/vscodeExts2nix > ${mutableExtensionsFilePath}
  '';
in
pkgs.buildEnv {
  name = "vscodeEnv";
  paths = [ code vscodeExts2nix ];
}
